import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/maintenance.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  // Example data - in a real app, this would come from repositories
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  MaintenanceBloc({FirebaseFirestore? firestore, FirebaseAuth? auth}) 
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(MaintenanceInitial()) {
    on<LoadMaintenanceRecordsEvent>(_onLoadMaintenanceRecords);
    on<AddMaintenanceEvent>(_onAddMaintenance);
    on<UpdateMaintenanceEvent>(_onUpdateMaintenance);
    on<DeleteMaintenanceEvent>(_onDeleteMaintenance);
  }

  Future<void> _onLoadMaintenanceRecords(
      LoadMaintenanceRecordsEvent event, Emitter<MaintenanceState> emit) async {
    emit(MaintenanceLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado.');

      final snapshot = await _firestore
          .collection('maintenances')
          .where('userId', isEqualTo: user.uid)
          .orderBy('dueDate', descending: false) // Ordena pelos mais próximos primeiro
          .get();

      final records = snapshot.docs
          .map((doc) => Maintenance.fromMap(doc.data(), doc.id))
          .toList();
      
      emit(MaintenanceRecordsLoaded(maintenanceRecords: records));
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao carregar manutenções: ${e.toString()}'));
    }
  }

  Future<void> _onAddMaintenance(
      AddMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    try {
      final recordMap = event.maintenance.toMap();
      await _firestore.collection('maintenances').add(recordMap);
      
      emit(MaintenanceAdded());
      add(LoadMaintenanceRecordsEvent()); // Recarrega a lista
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao adicionar manutenção: ${e.toString()}'));
    }
  }

  // MODIFICADO: Atualiza um registro existente no Firestore
  Future<void> _onUpdateMaintenance(
      UpdateMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    try {
      if (event.maintenance.id == null) throw Exception("ID da manutenção não pode ser nulo para atualizar.");
      
      final recordMap = event.maintenance.toMap();
      await _firestore.collection('maintenances').doc(event.maintenance.id).update(recordMap);
      
      emit(MaintenanceUpdated());
      add(LoadMaintenanceRecordsEvent());
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao atualizar manutenção: ${e.toString()}'));
    }
  }

  // MODIFICADO: Deleta um registro do Firestore
  Future<void> _onDeleteMaintenance(
      DeleteMaintenanceEvent event, Emitter<MaintenanceState> emit) async {
    try {
      await _firestore.collection('maintenances').doc(event.maintenanceId).delete();
      
      emit(MaintenanceDeleted());
      add(LoadMaintenanceRecordsEvent());
    } catch (e) {
      emit(MaintenanceError(message: 'Falha ao excluir manutenção: ${e.toString()}'));
    }
  }
}