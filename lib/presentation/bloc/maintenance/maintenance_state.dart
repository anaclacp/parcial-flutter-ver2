import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance.dart';

abstract class MaintenanceState extends Equatable {
  const MaintenanceState();

  @override
  List<Object?> get props => [];
}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceRecordsLoaded extends MaintenanceState {
  final List<Maintenance> maintenanceRecords;

  const MaintenanceRecordsLoaded({required this.maintenanceRecords});

  @override
  List<Object?> get props => [maintenanceRecords];
}

class MaintenanceAdded extends MaintenanceState {}

class MaintenanceUpdated extends MaintenanceState {}

class MaintenanceDeleted extends MaintenanceState {}

class MaintenanceError extends MaintenanceState {
  final String message;

  const MaintenanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
