import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({
    super.key, // Usa super.key aqui
    required this.trip,
    required this.onTap,
  }); 

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy', 'pt_BR');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.motorcycle,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title ?? 'Viagem sem Título',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip.startTime != null
                              ? dateFormat.format(trip.startTime!)
                              : 'Não Iniciada',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusChip(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.straighten,
                    'Distância',
                    trip.distance != null
                        ? '${trip.distance!.toStringAsFixed(2)} km'
                        : 'N/A',
                  ),
                  _buildStatItem(
                    Icons.timer_outlined,
                    'Duração',
                    trip.duration != null
                        ? '${trip.duration} min'
                        : 'N/A',
                  ),
                  _buildStatItem(
                    Icons.speed,
                    'Velocidade Média',
                    trip.averageSpeed != null
                        ? '${trip.averageSpeed!.toStringAsFixed(2)} km/h'
                        : 'N/A',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusChip() {
    if (trip.endTime == null && trip.startTime != null) {
      return Chip(
        label: const Text('Em Progresso'),
        backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    } else if (trip.endTime != null) {
      return Chip(
        label: const Text('Concluído'),
        backgroundColor: AppColors.success.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: AppColors.success,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    } else {
      return Chip(
        label: const Text('Não Iniciado'),
        backgroundColor: AppColors.mediumGray.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: AppColors.mediumGray,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }
  }
  
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mediumGray,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}

