import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/trip.dart';
import '../../../domain/entities/fuel_record.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TripBloc({FirebaseFirestore? firestore, FirebaseAuth? auth}) 
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(TripInitial()) {

    on<LoadTripsEvent>(_onLoadTrips);
    // on<LoadTripsEvent>(_onLoadTrips);
    // on<LoadTripPhotosEvent>(_onLoadTripPhotos);
    // on<LoadAllPhotosEvent>(_onLoadAllPhotos);
    on<CreateTripEvent>(_onCreateTrip);
    on<UpdateTripEvent>(_onUpdateTrip);
    on<DeleteTripEvent>(_onDeleteTrip);
    // on<StartTripRecordingEvent>(_onStartTripRecording);
    // on<StopTripRecordingEvent>(_onStopTripRecording);
    // on<DeletePhotoEvent>(_onDeletePhoto);
    
    on<LoadFuelRecordsEvent>(_onLoadFuelRecords);
    on<AddFuelRecordEvent>(_onAddFuelRecord);
    on<DeleteFuelRecordEvent>(_onDeleteFuelRecord);
  }

  Future<void> _onAddFuelRecord(AddFuelRecordEvent event, Emitter<TripState> emit) async {
    try {
      final recordMap = event.fuelRecord.toMap();

      await _firestore.collection('fuel_records').add(recordMap);

      emit(FuelRecordAdded());
      
      add(LoadFuelRecordsEvent());
      
    } catch (e) {
      emit(TripError(message: 'Falha ao adicionar registro: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFuelRecords(LoadFuelRecordsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }
      final snapshot = await _firestore
          .collection('fuel_records')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true) 
          .get();

      final fuelRecords = snapshot.docs.map((doc) {
        return FuelRecord.fromMap(doc.data(), doc.id);
      }).toList();
      
      emit(FuelRecordsLoaded(fuelRecords: fuelRecords));

    } catch (e) {
      emit(TripError(message: 'Falha ao carregar registros: ${e.toString()}'));
    }
  }

  // MODIFICADO: Handler para deletar um registro.
  Future<void> _onDeleteFuelRecord(DeleteFuelRecordEvent event, Emitter<TripState> emit) async {
    try {
      await _firestore.collection('fuel_records').doc(event.recordId).delete();
      emit(FuelRecordDeleted()); // Feedback para a UI
      add(LoadFuelRecordsEvent()); // Recarrega a lista
    } catch (e) {
      emit(TripError(message: 'Falha ao excluir registro: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTrips(LoadTripsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado.');

      final snapshot = await _firestore
          .collection('trips')
          .where('userId', isEqualTo: user.uid)
          .orderBy('startTime', descending: true) // Mostra as mais recentes primeiro
          .get();

      final trips = snapshot.docs
          .map((doc) => Trip.fromMap(doc.data(), doc.id))
          .toList();
      
      emit(TripsLoaded(trips: trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao carregar viagens: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTrip(CreateTripEvent event, Emitter<TripState> emit) async {
    try {
      final tripMap = event.trip.toMap();
      await _firestore.collection('trips').add(tripMap);
      
      emit(TripCreated());
      add(LoadTripsEvent()); // Recarrega a lista
    } catch (e) {
      emit(TripError(message: 'Falha ao criar viagem: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTrip(UpdateTripEvent event, Emitter<TripState> emit) async {
    try {
      if (event.trip.id == null) throw Exception("ID da viagem não pode ser nulo para atualizar.");

      final tripMap = event.trip.toMap();
      await _firestore.collection('trips').doc(event.trip.id).update(tripMap);
      
      emit(TripUpdated());
      add(LoadTripsEvent()); 
    } catch (e) {
      emit(TripError(message: 'Falha ao atualizar viagem: ${e.toString()}'));
    }
  }
  
  Future<void> _onDeleteTrip(DeleteTripEvent event, Emitter<TripState> emit) async {
    try {
      if (event.trip.id == null) throw Exception("ID da viagem não pode ser nulo para deletar.");

      await _firestore.collection('trips').doc(event.trip.id).delete();
      
      emit(TripDeleted());
      add(LoadTripsEvent());
    } catch (e) {
      emit(TripError(message: 'Falha ao excluir viagem: ${e.toString()}'));
    }
  }
}