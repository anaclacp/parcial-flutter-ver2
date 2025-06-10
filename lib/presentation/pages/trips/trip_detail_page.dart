import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart'; 
import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;

  const TripDetailPage({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripsLoaded) {
              final updatedTrip = state.trips.firstWhere(
                (t) => t.id == widget.trip.id,
                orElse: () => widget.trip,
              );
              return Text(updatedTrip.title ?? 'Detalhes da Viagem');
            }
            return Text(widget.trip.title ?? 'Detalhes da Viagem');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/trip/edit',
                arguments: widget.trip,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Detalhes'),
            Tab(text: 'Mapa'),
            Tab(text: 'Fotos'),
          ],
        ),
      ),
      body: BlocListener<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viagem excluída com sucesso.'), backgroundColor: Colors.green),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is TripError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is TripsLoaded) {
              final Trip updatedTrip = state.trips.firstWhere(
                (trip) => trip.id == widget.trip.id,
                orElse: () => widget.trip,
              );

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(updatedTrip),
                  _buildMapTab(updatedTrip),
                  _buildPhotosTab(updatedTrip),
                ],
              );
            }
            
            // O nome 'TripError' está correto.
            if (state is TripError) {
              return Center(child: Text("Erro ao carregar dados: ${state.message}"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildDetailsTab(Trip currentTrip) {
    final dateFormat = DateFormat('dd MMM, yyyy', 'pt_BR');
    final timeFormat = DateFormat('HH:mm', 'pt_BR');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status da viagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                      _buildStatusChip(currentTrip),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Data de Início',
                    currentTrip.startTime != null
                        ? '${dateFormat.format(currentTrip.startTime!)} às ${timeFormat.format(currentTrip.startTime!)}'
                        : 'Não definido',
                    Icons.play_circle_outline,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Data de Término',
                    currentTrip.endTime != null
                        ? '${dateFormat.format(currentTrip.endTime!)} às ${timeFormat.format(currentTrip.endTime!)}'
                        : 'Em andamento ou não definido',
                    Icons.stop_circle_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Duração',
                    currentTrip.duration != null ? '${currentTrip.duration} minutos' : 'N/A',
                    Icons.timer_outlined,
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detalhes da Viagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Distância',
                    currentTrip.distance != null ? '${currentTrip.distance!.toStringAsFixed(2)} km' : 'N/A',
                    Icons.straighten,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Velocidade Máxima',
                    currentTrip.maxSpeed != null ? '${currentTrip.maxSpeed!.toStringAsFixed(2)} km/h' : 'N/A',
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notas da Viagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                  const SizedBox(height: 16),
                  Text(
                    currentTrip.notes ?? 'Nenhuma nota adicionada para esta viagem.',
                    style: const TextStyle(fontSize: 16, color: AppColors.darkGray, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab(Trip currentTrip) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_outlined, size: 80, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          Text('Mapa para ${currentTrip.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
          const SizedBox(height: 8),
          const Text('Funcionalidade de mapa ainda não implementada.', style: TextStyle(fontSize: 16, color: AppColors.mediumGray), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(Trip currentTrip) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library_outlined, size: 80, color: AppColors.mediumGray),
          const SizedBox(height: 16),
          const Text('Fotos da viagem', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
          const SizedBox(height: 8),
          const Text('Nenhuma foto foi adicionada para esta viagem ainda', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Adicionar Foto'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(Trip currentTrip) {
    if (currentTrip.endTime != null) {
      return Chip(
        label: const Text('Concluída'),
        backgroundColor: AppColors.success.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
        avatar: const Icon(Icons.check_circle, color: AppColors.success, size: 16),
      );
    } else {
      return Chip(
        label: const Text('Pendente'),
        backgroundColor: AppColors.warning.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold),
        avatar: const Icon(Icons.hourglass_top_outlined, color: AppColors.warning, size: 16),
      );
    }
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.mediumGray)),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.darkGray),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir viagem'),
        content: const Text('Tem certeza que deseja excluir esta viagem? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<TripBloc>().add(DeleteTripEvent(trip: widget.trip));
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}