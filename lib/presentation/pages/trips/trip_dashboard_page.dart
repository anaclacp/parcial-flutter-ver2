import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcial/presentation/bloc/auth/auth_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_event.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/trip/trip_card.dart';
import '../../widgets/trip/trip_stats_widget.dart';

class TripDashboardPage extends StatefulWidget {
  const TripDashboardPage({super.key});

  @override
  State<TripDashboardPage> createState() => _TripDashboardPageState();
}

class _TripDashboardPageState extends State<TripDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TripBloc>().add(LoadTripsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Viagens'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Viagens',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade de filtro ainda não implementada.')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TripBloc>().add(LoadTripsEvent());
            },
            child: _buildBodyContent(context, state),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/trip/create');
        },
        tooltip: 'Adicionar Nova Viagem',
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, TripState state) {
    // 1. Tratar o Estado de Erro
    if (state is TripError) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar viagens:\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.darkGray, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TripBloc>().add(LoadTripsEvent()),
                  child: const Text('Tentar Novamente'),
                )
              ],
            ),
          ),
        ),
      );
    }

    // 2. Tratar o Estado Carregado
    if (state is TripsLoaded) {
      final trips = state.trips;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripStatsWidget(
              totalTrips: trips.length,
              totalDistance: trips.fold(0.0, (sum, trip) => sum + (trip.distance ?? 0)),
              longestTrip: trips.fold(0.0, (max, trip) => trip.distance != null && trip.distance! > max ? trip.distance! : max),
            ),
            const SizedBox(height: 24),
            const Text(
              'Viagens Recentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray),
            ),
            const SizedBox(height: 16),
            trips.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return TripCard(
                        trip: trip,
                        onTap: () {
                          Navigator.of(context).pushNamed('/viagem/detalhe', arguments: trip);
                        },
                      );
                    },
                  ),
          ],
        ),
      );
    }

    // 3. Estado de Carregamento
    return const Center(child: LoadingIndicator(message: 'Carregando viagens...'));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.motorcycle_outlined,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma viagem registrada ainda',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Comece a registrar suas aventuras de moto',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/trip/create');
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar Nova Viagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;
        final String userName = user?.displayName ?? 'Usuário';
        final String userEmail = user?.email ?? 'email@exemplo.com';
        final String? profilePhotoUrl = user?.photoURL;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.white.withAlpha(50),
                        backgroundImage: profilePhotoUrl != null 
                            ? NetworkImage(profilePhotoUrl) 
                            : null,
                        child: profilePhotoUrl == null
                            ? const Icon(Icons.person, size: 40, color: AppColors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: AppColors.white.withAlpha(204),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user?.emailVerified == false) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Email não verificado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: AppColors.primaryColor),
                title: const Text('Dashboard'),
                selected: ModalRoute.of(context)?.settings.name == '/dashboard',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
                title: const Text('Galeria de Fotos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/fotos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_gas_station, color: AppColors.primaryColor),
                title: const Text('Consumo de Combustível'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/combustivel');
                },
              ),
              ListTile(
                leading: const Icon(Icons.build, color: AppColors.primaryColor),
                title: const Text('Manutenção'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/manutencao');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primaryColor),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/configuracoes');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppColors.primaryColor),
                title: const Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sobre');
                },
              ),
              if (user?.emailVerified == false) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.mark_email_read, color: Colors.orange),
                  title: const Text('Verificar Email'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await user?.sendEmailVerification();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email de verificação enviado!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao enviar email: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.secondaryColor),
                title: const Text('Sair'),
                onTap: () => _handleSignOut(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Tem certeza que deseja sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Fecha o drawer
                
                // Dispara o evento de logout no AuthBloc
                context.read<AuthBloc>().add(SignOutRequested());
                
                // Mostra feedback visual
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saindo da conta...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondaryColor,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}