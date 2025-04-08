import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/maintenance.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  // Example data - in a real app, this would come from repositories
  final List<Maintenance> _maintenanceRecords = [
    Maintenance(
      id: '1',
      title: 'Troca de Óleo',
      description: 'Troca de óleo regular com substituição do filtro',
      type: MaintenanceType.oilChange,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      odometerThreshold: 13000,
      status: MaintenanceStatus.pending,
      notes: 'Use óleo sintético 10W-40',
    ),
    Maintenance(
      id: '2',
      title: 'Verificação de Pressão dos Pneus',
      description: 'Verificar e ajustar a pressão dos pneus',
      type: MaintenanceType.tireMaintenance,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      odometerThreshold: 12800,
      status: MaintenanceStatus.pending,
      notes: 'Dianteiro: 32 PSI, Traseiro: 36 PSI',
    ),
    Maintenance(
      id: '3',
      title: 'Lubrificação da Corrente',
      description: 'Limpar e lubrificar a corrente',
      type: MaintenanceType.chainLubrication,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      odometerThreshold: 12700,
      status: MaintenanceStatus.overdue,
      notes: 'Use lubrificante específico para corrente',
    ),
    Maintenance(
      id: '4',
      title: 'Substituição de Pastilhas de Freio',
      description: 'Substituir pastilhas de freio dianteiras e traseiras',
      type: MaintenanceType.brakeService,
      dueDate: DateTime.now().subtract(const Duration(days: 10)),
      odometerThreshold: 12500,
      status: MaintenanceStatus.completed,
      notes: 'Use pastilhas de freio cerâmicas',
      completedDate: DateTime.now().subtract(const Duration(days: 10)),
      completedOdometer: 12500,
      completionNotes: 'Substituídas as pastilhas dianteiras e traseiras. Também limpei os calipers de freio.',
    ),
  ];

  MaintenanceBloc() : super(MaintenanceInitial()) {
    on<LoadMaintenanceRecordsEvent>(_onLoadMaintenanceRecords);
    on<AddMaintenanceEvent>(_onAddMaintenance);
    on<UpdateMaintenanceEvent>(_onUpdateMaintenance);
    on<DeleteMaintenanceEvent>(_onDeleteMaintenance);
  }

  FutureOr<void> _onLoadMaintenanceRecords(
      LoadMaintenanceRecordsEvent event, Emitter<MaintenanceState> emit) async {
    emit(MaintenanceLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      emit(MaintenanceRecordsLoaded(maintenanceRecords: _maintenanceRecords));
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao carregar os registros de manutenção: ${e.toString()}'));
    }
  }

  FutureOr<void> _onAddMaintenance(
      AddMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    emit(MaintenanceLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add to local list
      _maintenanceRecords.add(event.maintenance);
      
      emit(MaintenanceAdded());
      emit(MaintenanceRecordsLoaded(maintenanceRecords: _maintenanceRecords));
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao adicionar manutenção: ${e.toString()}'));
    }
  }

  FutureOr<void> _onUpdateMaintenance(
      UpdateMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    emit(MaintenanceLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update in local list
      final index = _maintenanceRecords.indexWhere((record) => record.id == event.maintenance.id);
      if (index != -1) {
        _maintenanceRecords[index] = event.maintenance;
      }
      
      emit(MaintenanceUpdated());
      emit(MaintenanceRecordsLoaded(maintenanceRecords: _maintenanceRecords));
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao atualizar a manutenção: ${e.toString()}'));
    }
  }

  FutureOr<void> _onDeleteMaintenance(
      DeleteMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    emit(MaintenanceLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Remove from local list
      _maintenanceRecords.removeWhere((record) => record.id == event.maintenanceId);
      
      emit(MaintenanceDeleted());
      emit(MaintenanceRecordsLoaded(maintenanceRecords: _maintenanceRecords));
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao excluir a manutenção: ${e.toString()}'));
    }
  }
}
