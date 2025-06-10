import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  }); 

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy', 'pt_BR');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: AppColors.primaryColor.withOpacity(0.1),
                      child: trip.coverPhotoUrl != null && trip.coverPhotoUrl!.isNotEmpty
                          ? Image.asset(
                              trip.coverPhotoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: AppColors.mediumGray,
                                    size: 32,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.motorcycle,
                                color: AppColors.primaryColor,
                                size: 32,
                              ),
                            ),
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
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip.startTime != null
                              ? dateFormat.format(trip.startTime!)
                              : 'Data não definida',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    Icons.straighten,
                    'Distância',
                    trip.distance != null
                        ? '${trip.distance!.toStringAsFixed(1)} km'
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
                    Icons.trending_up, 
                    'Vel. Máxima',   
                    trip.maxSpeed != null
                        ? '${trip.maxSpeed!.toStringAsFixed(0)} km/h' 
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