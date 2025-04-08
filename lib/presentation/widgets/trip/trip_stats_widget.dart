import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TripStatsWidget extends StatelessWidget {
  final int totalTrips;
  final double totalDistance;
  final double longestTrip;

  const TripStatsWidget({
    super.key, // Usa super.key aqui
    required this.totalTrips,
    required this.totalDistance,
    required this.longestTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estatísticas da Viagem',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.route,
                  'Total de Viagens',
                  totalTrips.toString(),
                ),
                _buildStatItem(
                  Icons.straighten,
                  'Distância Total',
                  '${totalDistance.toStringAsFixed(2)} km',
                ),
                _buildStatItem(
                  Icons.timeline,
                  'Viagem Mais Longa',
                  '${longestTrip.toStringAsFixed(2)} km',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.mediumGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}

