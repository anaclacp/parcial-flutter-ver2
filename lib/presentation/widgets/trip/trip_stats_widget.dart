import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TripStatsWidget extends StatelessWidget {
  final int totalTrips;
  final double totalDistance;
  final double topSpeed;

  const TripStatsWidget({
    super.key,
    required this.totalTrips,
    required this.totalDistance,
    required this.topSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suas Estatísticas Gerais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.route_outlined,
                    'Viagens',
                    totalTrips.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.map_outlined,
                    'Distância Total',
                    '${totalDistance.toStringAsFixed(0)} km',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.rocket_launch_outlined,
                    'Top Speed',
                    '${topSpeed.toStringAsFixed(0)} km/h',
                  ),
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
          textAlign: TextAlign.center, 
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