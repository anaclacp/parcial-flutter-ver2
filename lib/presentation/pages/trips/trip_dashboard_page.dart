import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../widgets/common/loading_indicator.dart'; // Ajuste o caminho se necessário
import '../../widgets/trip/trip_card.dart';
import '../../widgets/trip/trip_stats_widget.dart';

class TripDashboardPage extends StatefulWidget {
  const TripDashboardPage({super.key});

  @override
  State<TripDashboardPage> createState() => _TripDashboardPageState();
}

class _TripDashboardPageState extends State<TripDashboardPage> {
  String? _profileImagePath;
  String _motoModel = 'R3 2026';
  String _motoColor = 'Branca';

  @override
  void initState() {
    super.initState();
    _profileImagePath = 'assets/images/ana_foto_perfil.jpg';

    // Disparar o evento para carregar as viagens do BLoC após o primeiro frame
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
          // O RefreshIndicator agora envolve o _buildBodyContent
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TripBloc>().add(LoadTripsEvent());
               // Espera o próximo estado que não seja loading
               await context.read<TripBloc>().stream.firstWhere(
                    (nextState) => nextState is! TripLoading,
               );
            },
            child: _buildBodyContent(context, state), // Chama o método auxiliar corrigido
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/trip/create'); // CONFIRME ROTA
        },
        tooltip: 'Adicionar Nova Viagem',
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // -- Método auxiliar para construir o corpo baseado no estado do BLoC (CORRIGIDO) --
  Widget _buildBodyContent(BuildContext context, TripState state) {
    // 1. Tratar o Estado de Erro Primeiro
    if (state is TripError) {
      return Center( // Envolve com Center para ocupar espaço e permitir scroll do RefreshIndicator
         child: SingleChildScrollView( // Permite scroll se o erro for grande
           physics: const AlwaysScrollableScrollPhysics(), // Garante que o refresh funcione
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

    // 2. Tratar o Estado Carregado (SUCESSO)
    if (state is TripsLoaded) {
      final trips = state.trips;

      // A estrutura principal com SingleChildScrollView permite o RefreshIndicator funcionar
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripStatsWidget(
              totalTrips: trips.length,
              totalDistance: trips.fold(0.0,(sum, trip) => sum + (trip.distance ?? 0)),
              longestTrip: trips.fold(0.0,(max, trip) => trip.distance != null && trip.distance! > max ? trip.distance! : max),
            ),
            const SizedBox(height: 24),
            const Text('Viagens Recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
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
                          Navigator.of(context).pushNamed('/viagem/detalhe', arguments: trip); // CONFIRME ROTA
                        },
                      );
                    },
                  ),
          ],
        ),
      );
    }

    // 3. Tratar o Estado de Carregamento ou Inicial
    // Mostra o indicador centralizado. O RefreshIndicator também terá seu próprio spinner ao puxar.
    return const Center(child: LoadingIndicator(message: 'Carregando viagens...'));
  }

  Widget _buildEmptyState() {
    // Adicionado Center para garantir que o RefreshIndicator tenha um child com tamanho
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
                Navigator.of(context).pushNamed('/trip/create'); // CONFIRME a rota
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
    const String userName = 'Ana Clara'; // Nome fixo
    const String userEmail = 'ana@gmail.com'; // Email fixo

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: _selectProfileImage, // Permite mudar a foto
                      borderRadius: BorderRadius.circular(35),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.white.withAlpha(50),
                            backgroundImage: _profileImagePath != null
                                ? AssetImage(_profileImagePath!) // Mostra a imagem do asset
                                : null,
                            child: _profileImagePath == null
                                ? const Icon( // Ícone padrão se não houver imagem
                                    Icons.motorcycle,
                                    size: 40,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          // Ícone de editar foto
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName, // Nome do usuário
                    style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userEmail, // Email do usuário
                    style: TextStyle(color: AppColors.white.withAlpha(204), fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Dados da Moto
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Modelo: $_motoModel', style: TextStyle(color: AppColors.white.withAlpha(180), fontSize: 12), overflow: TextOverflow.ellipsis),
                            Text('Cor: $_motoColor', style: TextStyle(color: AppColors.white.withAlpha(180), fontSize: 12), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      
                      InkWell(
                        onTap: _showEditMotoDialog,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.edit, color: AppColors.white.withAlpha(180), size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppColors.primaryColor),
            title: const Text('Painel de Viagens'),
            selected: ModalRoute.of(context)?.settings.name == '/', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/') { // CONFIRME ROTA
                Navigator.pushReplacementNamed(context, '/'); // CONFIRME ROTA
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
            title: const Text('Galeria de Fotos'),
            selected: ModalRoute.of(context)?.settings.name == '/fotos', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/fotos'); // CONFIRME ROTA
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_gas_station, color: AppColors.primaryColor),
            title: const Text('Consumo de Combustível'),
            selected: ModalRoute.of(context)?.settings.name == '/combustível', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/combustível'); // CONFIRME ROTA
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: AppColors.primaryColor),
            title: const Text('Manutenção'),
            selected: ModalRoute.of(context)?.settings.name == '/manutenção', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/manutenção'); // CONFIRME ROTA
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primaryColor),
            title: const Text('Configurações'),
            selected: ModalRoute.of(context)?.settings.name == '/configurações', // CONFIRME ROTA (se existir)
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Página de Configurações ainda não implementada.')),
              );
              // Navigator.pushNamed(context, '/configurações'); // CONFIRME ROTA (se existir)
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primaryColor),
            title: const Text('Sobre'),
            selected: ModalRoute.of(context)?.settings.name == '/sobre', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sobre'); // CONFIRME ROTA
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.secondaryColor),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false); // CONFIRME ROTA
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectProfileImage() async {
     final exampleImages = [
      'assets/images/ana_foto_perfil.jpg',
      'assets/fixed_photos/moto_exemplo_1.jpg',
      'assets/fixed_photos/moto_exemplo_2.jpg',
    ];
    final currentIndex = _profileImagePath != null ? exampleImages.indexOf(_profileImagePath!) : -1;
    final nextIndex = (currentIndex + 1) % exampleImages.length;
    final selectedPath = exampleImages[nextIndex];
    print('Imagem de perfil selecionada (simulado): $selectedPath');
    setState(() { _profileImagePath = selectedPath; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada (simulado)!')),
      );
    }
  }

  void _showEditMotoDialog() {
    final modelController = TextEditingController(text: _motoModel);
    final colorController = TextEditingController(text: _motoColor);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar Dados da Moto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Modelo')),
              const SizedBox(height: 16),
              TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                setState(() {
                  _motoModel = modelController.text;
                  _motoColor = colorController.text;
                });
                Navigator.pop(dialogContext);
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Dados da moto atualizados (localmente)!')),
                 );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    ).then((_) {
      modelController.dispose();
      colorController.dispose();
    });
  }
}