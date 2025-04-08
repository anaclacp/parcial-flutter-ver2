import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../widgets/common/loading_indicator.dart';

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
  bool _isRecording = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // If this is a new trip being created, set recording to true
    _isRecording = widget.trip.endTime == null;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      // Start recording
      context.read<TripBloc>().add(StartTripRecordingEvent(trip: widget.trip));
    } else {
      // Stop recording
      context.read<TripBloc>().add(StopTripRecordingEvent(trip: widget.trip));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.title ?? 'Detalhes da Viagem'),
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
          labelColor: Colors.white, // Cor do texto da aba SELECIONADA (ex: branco)
          unselectedLabelColor: Colors.white70, // Cor do texto das abas NÃO SELECIONADAS (ex: branco semitransparente)
          indicatorColor: Colors.white, // Cor da linha indicadora (ex: branco)
          tabs: const [
            Tab(text: 'Detalhes'),
            Tab(text: 'Mapa'),
            Tab(text: 'Fotos'),
          ],
        ),
      ),
      body: BlocConsumer<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripDeleted) {
            Navigator.of(context).pop();
          } else if (state is TripError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TripLoading) {
            return const LoadingIndicator();
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              // Details Tab
              _buildDetailsTab(),
              
              // Map Tab
              _buildMapTab(),
              
              // Photos Tab
              _buildPhotosTab(),
            ],
          );
        },
      ),
      floatingActionButton: _isRecording
          ? FloatingActionButton(
              onPressed: _toggleRecording,
              backgroundColor: AppColors.secondaryColor,
              child: const Icon(Icons.stop),
            )
          : FloatingActionButton(
              onPressed: _toggleRecording,
              backgroundColor: AppColors.accentColor,
              child: const Icon(Icons.play_arrow),
            ),
    );
  }
  
  Widget _buildDetailsTab() {
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
                      const Text(
                        'Status da viagem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      _buildStatusChip(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Iniciada',
                    widget.trip.startTime != null
                        ? '${dateFormat.format(widget.trip.startTime!)} às ${timeFormat.format(widget.trip.startTime!)}'
                        : 'Não iniciada',
                    Icons.play_circle_outline,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Terminada',
                    widget.trip.endTime != null
                        ? '${dateFormat.format(widget.trip.endTime!)} às ${timeFormat.format(widget.trip.endTime!)}'
                        : 'Em progresso',
                    Icons.stop_circle_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Duração',
                    widget.trip.duration != null
                        ? '${widget.trip.duration} minutos'
                        : 'N/A',
                    Icons.timer_outlined,
                  ),
                ],
              ),
            ),
          ),
          
          // Trip Details Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalhes da Viagem',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Distância',
                    widget.trip.distance != null
                        ? '${widget.trip.distance!.toStringAsFixed(2)} km'
                        : 'N/A',
                    Icons.straighten,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Velocidade Média',
                    widget.trip.averageSpeed != null
                        ? '${widget.trip.averageSpeed!.toStringAsFixed(2)} km/h'
                        : 'N/A',
                    Icons.speed,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Velocidade Máxima',
                    widget.trip.maxSpeed != null
                        ? '${widget.trip.maxSpeed!.toStringAsFixed(2)} km/h'
                        : 'N/A',
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
          ),
          
          // Trip Notes Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notas da Viagem',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.trip.notes ?? 'Nenhuma nota adicionada para esta viagem.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGray,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMapTab() {
    // This would be implemented with a map package like google_maps_flutter
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map_outlined,
            size: 80,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 16),
          const Text(
            'Mapa da Rota da Viagem',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isRecording
                ? 'Gravação em progresso...'
                : 'Nenhuma rota registrada para ${widget.trip.title}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhotosTab() {
    // This would display photos taken during the trip
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 16),
          const Text(
            'Fotos da viagem',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nenhuma foto foi adicionada para esta viagem ainda',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Add photo functionality
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Adicionar Foto'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusChip() {
    if (_isRecording) {
      return Chip(
        label: const Text('Gravando'),
        backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.bold,
        ),
        avatar: const Icon(
          Icons.fiber_manual_record,
          color: AppColors.secondaryColor,
          size: 16,
        ),
      );
    } else if (widget.trip.endTime != null) {
      return Chip(
        label: const Text('Concluída'),
        backgroundColor: AppColors.success.withAlpha(51),
        labelStyle: const TextStyle(
          color: AppColors.success,
          fontWeight: FontWeight.bold,
        ),
        avatar: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 16,
        ),
      );
    } else {
      return Chip(
        label: const Text('Pausada'),
        backgroundColor: AppColors.warning.withAlpha(51),
        labelStyle: const TextStyle(
          color: AppColors.warning,
          fontWeight: FontWeight.bold,
        ),
        avatar: const Icon(
          Icons.pause_circle_filled,
          color: AppColors.warning,
          size: 16,
        ),
      );
    }
  }
  
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGray,
                ),
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
      builder: (context) => AlertDialog(
        title: const Text('Apagar viagem'),
        content: const Text(
          'Tem certeza que deseja excluir esta viagem? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TripBloc>().add(DeleteTripEvent(trip: widget.trip));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

