import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/maintenance.dart';

class MaintenanceCard extends StatelessWidget {
  final Maintenance maintenance;
  final bool isHistory;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MaintenanceCard({
    super.key, // Usa super.key aqui
    required this.maintenance,
    this.isHistory = false,
    this.onMarkComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy', 'pt_BR');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getTypeColor().withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: _getTypeColor(),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maintenance.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        maintenance.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isHistory && onDelete != null)
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          value: 'editar',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 18),
                              const SizedBox(width: 8),
                              const Text('Editar'),
                            ],
                          ),
                        ),
                      if (onMarkComplete != null)
                        PopupMenuItem(
                          value: 'concluído',
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 18),
                              const SizedBox(width: 8),
                              const Text('Marcar como Concluído'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'excluir',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 18, color: AppColors.secondaryColor),
                              const SizedBox(width: 8),
                              const Text('Excluir', style: TextStyle(color: AppColors.secondaryColor)),
                            ],
                          ),
                        ),
                    ],
                    onSelected: (value) {
                      if (value == 'editar' && onEdit != null) {
                        onEdit!();
                      } else if (value == 'concluído' && onMarkComplete != null) {
                        onMarkComplete!();
                      } else if (value == 'excluir' && onDelete != null) {
                        onDelete!();
                      }
                    },
                  ),
                if (isHistory && onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.secondaryColor),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  isHistory ? 'Concluído' : 'Data de validade',
                  isHistory && maintenance.completedDate != null
                      ? dateFormat.format(maintenance.completedDate!)
                      : dateFormat.format(maintenance.dueDate),
                  Icons.calendar_today,
                ),
                _buildInfoItem(
                  'Odômetro',
                  isHistory && maintenance.completedOdometer != null
                      ? '${maintenance.completedOdometer!.toStringAsFixed(0)} km'
                      : '${maintenance.odometerThreshold.toStringAsFixed(0)} km',
                  Icons.speed,
                ),
                _buildStatusChip(),
              ],
            ),
            if (!isHistory && maintenance.status != MaintenanceStatus.completed && onMarkComplete != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onMarkComplete,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Marcar como Concluído'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                  ),
                ),
              ),
            ],
            if (isHistory && maintenance.completionNotes != null && maintenance.completionNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Notas de Conclusão:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                maintenance.completionNotes!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;
    
    switch (maintenance.status) {
      case MaintenanceStatus.pending:
        chipColor = AppColors.warning;
        statusText = 'Pendente';
        break;
      case MaintenanceStatus.overdue:
        chipColor = AppColors.secondaryColor;
        statusText = 'Atrasado';
        break;
      case MaintenanceStatus.completed:
        chipColor = AppColors.success;
        statusText = 'Concluído';
        break;
    }
    
    return Chip(
      label: Text(statusText),
      backgroundColor: chipColor.withAlpha(51),
      labelStyle: TextStyle(
        color: chipColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
  
  IconData _getTypeIcon() {
    switch (maintenance.type) {
      case MaintenanceType.oilChange:
        return Icons.oil_barrel;
      case MaintenanceType.tireMaintenance:
        return Icons.tire_repair;
      case MaintenanceType.chainLubrication:
        return Icons.link;
      case MaintenanceType.brakeService:
        return Icons.warning_amber;
      case MaintenanceType.generalService:
        return Icons.build;
      case MaintenanceType.other:
        return Icons.miscellaneous_services;
    }
  }
  
  Color _getTypeColor() {
    switch (maintenance.type) {
      case MaintenanceType.oilChange:
        return AppColors.primaryColor;
      case MaintenanceType.tireMaintenance:
        return AppColors.accentColor;
      case MaintenanceType.chainLubrication:
        return Colors.purple;
      case MaintenanceType.brakeService:
        return AppColors.secondaryColor;
      case MaintenanceType.generalService:
        return AppColors.info;
      case MaintenanceType.other:
        return AppColors.mediumGray;
    }
  }
}

