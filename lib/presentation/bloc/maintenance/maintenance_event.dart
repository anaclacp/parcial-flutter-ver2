import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance.dart';

abstract class MaintenanceEvent extends Equatable {
  const MaintenanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMaintenanceRecordsEvent extends MaintenanceEvent {}

class AddMaintenanceEvent extends MaintenanceEvent {
  final Maintenance maintenance;

  const AddMaintenanceEvent({required this.maintenance});

  @override
  List<Object?> get props => [maintenance];
}

class UpdateMaintenanceEvent extends MaintenanceEvent {
  final Maintenance maintenance;

  const UpdateMaintenanceEvent({required this.maintenance});

  @override
  List<Object?> get props => [maintenance];
}

class DeleteMaintenanceEvent extends MaintenanceEvent {
  final String maintenanceId;

  const DeleteMaintenanceEvent({required this.maintenanceId});

  @override
  List<Object?> get props => [maintenanceId];
}
