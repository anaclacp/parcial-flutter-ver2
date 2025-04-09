import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/photo.dart';
import '../../../domain/entities/fuel_record.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  // Example data - in a real app, this would come from repositories
  final List<Trip> _trips = [
    Trip(
      id: '1',
      title: 'Viagem de Jaboticabal a Avaré para Acampamento',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      distance: 246.0,
      duration: 180, 
      averageSpeed: 82.2,
      maxSpeed: 110.0,
      notes: 'Viagem de Jaboticabal a Avaré com destino ao Camping Municipal às margens da Represa de Jurumirim. Percurso tranquilo com belas paisagens e oportunidade para atividades aquáticas.',
      coverPhotoUrl: 'assets/images/camping-avare.png',
    ),
    Trip(
      id: '2',
      title: 'Viagem de Ribeirão Preto a Olímpia - Thermas dos Laranjais',
      startTime: DateTime.now().subtract(const Duration(days: 7)),
      endTime: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
      distance: 133.0,
      duration: 120, 
      averageSpeed: 66.5,
      maxSpeed: 100.0,
      notes: 'Viagem de Ribeirão Preto a Olímpia para aproveitar um dia no Thermas dos Laranjais, com diversas atrações aquáticas e águas termais.',
      coverPhotoUrl: 'assets/images/thermas.png',
    ),
    Trip(
      id: '3',
      title: 'Viagem de Jaboticabal a Bueno de Andrada para saborear as coxinhas douradas',
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 1, minutes: 45)),
      distance: 53.0,
      duration: 50, 
      averageSpeed: 90.0,
      maxSpeed: 130.0,
      notes: 'Viagem de Jaboticabal a Bueno de Andrada para degustar as famosas coxinhas da região, conhecidas por seu sabor e tradição.',
      coverPhotoUrl: 'assets/images/bueno-de-andrada.png',
    ),
  ];

  final List<Photo> _photos = [
    Photo(
      id: '1',
      url: 'assets/images/camping-avare.png',
      caption: 'Camping',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      location: GeoLocation(latitude: 37.7749, longitude: -122.4194),
      tripId: '1',
    ),
    Photo(
      id: '3',
      url: 'assets/images/bueno-de-andrada.jpg',
      caption: 'Bueno de Andrada',
      timestamp: DateTime.now().subtract(const Duration(days: 7, hours: 3)),
      location: GeoLocation(latitude: 34.0522, longitude: -118.2437),
      tripId: '2',
    ),
  ];

  final List<FuelRecord> _fuelRecords = [
    FuelRecord(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 5)),
      odometer: 12500,
      amount: 15.5,
      cost: 62.0,
      fuelEconomy: 18.2,
      notes: 'Gasolina aditivada no posto Ipiranga',
    ),
    FuelRecord(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 12)),
      odometer: 12200,
      amount: 14.8,
      cost: 59.2,
      fuelEconomy: 17.8,
      notes: 'Combustível premium na Chevron',
    ),
  ];

  TripBloc() : super(TripInitial()) {
    on<LoadTripsEvent>(_onLoadTrips);
    on<LoadTripPhotosEvent>(_onLoadTripPhotos);
    on<LoadAllPhotosEvent>(_onLoadAllPhotos);
    on<LoadFuelRecordsEvent>(_onLoadFuelRecords);
    on<AddFuelRecordEvent>(_onAddFuelRecord);
    on<DeleteFuelRecordEvent>(_onDeleteFuelRecord);
    on<CreateTripEvent>(_onCreateTrip);
    on<UpdateTripEvent>(_onUpdateTrip);
    on<DeleteTripEvent>(_onDeleteTrip);
    on<StartTripRecordingEvent>(_onStartTripRecording);
    on<StopTripRecordingEvent>(_onStopTripRecording);
    on<DeletePhotoEvent>(_onDeletePhoto);
  }

  FutureOr<void> _onLoadTrips(LoadTripsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao carregar as viagens: ${e.toString()}'));
    }
  }

  FutureOr<void> _onLoadTripPhotos(LoadTripPhotosEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final tripPhotos = _photos.where((photo) => photo.tripId == event.tripId).toList();
      emit(PhotosLoaded(photos: tripPhotos));
    } catch (e) {
      emit(TripError(message: 'Falha ao carregar a foto: ${e.toString()}'));
    }
  }

  FutureOr<void> _onLoadAllPhotos(LoadAllPhotosEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      emit(PhotosLoaded(photos: _photos));
    } catch (e) {
      emit(TripError(message: 'Falha ao carregar a foto: ${e.toString()}'));
    }
  }

  FutureOr<void> _onLoadFuelRecords(LoadFuelRecordsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      emit(FuelRecordsLoaded(fuelRecords: _fuelRecords));
    } catch (e) {
      emit(TripError(message: 'Falha ao carregar os registros de combustível: ${e.toString()}'));
    }
  }

  FutureOr<void> _onAddFuelRecord(AddFuelRecordEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add to local list
      _fuelRecords.add(event.fuelRecord);
      
      emit(FuelRecordAdded());
      emit(FuelRecordsLoaded(fuelRecords: _fuelRecords));
    } catch (e) {
      emit(TripError(message: 'Falha ao adicionar registro de combustível: ${e.toString()}'));
    }
  }

  FutureOr<void> _onDeleteFuelRecord(DeleteFuelRecordEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Remove from local list
      _fuelRecords.removeWhere((record) => record.id == event.recordId);
      
      emit(FuelRecordDeleted());
      emit(FuelRecordsLoaded(fuelRecords: _fuelRecords));
    } catch (e) {
      emit(TripError(message: 'Falha ao excluir registro de combustível: ${e.toString()}'));
    }
  }

  FutureOr<void> _onCreateTrip(CreateTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add to local list
      _trips.add(event.trip);
      
      emit(TripCreated());
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao criar viagem: ${e.toString()}'));
    }
  }

  FutureOr<void> _onUpdateTrip(UpdateTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update in local list
      final index = _trips.indexWhere((trip) => trip.id == event.trip.id);
      if (index != -1) {
        _trips[index] = event.trip;
      }
      
      emit(TripUpdated());
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao atualizar a viagem: ${e.toString()}'));
    }
  }

  FutureOr<void> _onDeleteTrip(DeleteTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Remove from local list
      _trips.removeWhere((trip) => trip.id == event.trip.id);
      
      emit(TripDeleted());
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao excluir a viagem: ${e.toString()}'));
    }
  }

  FutureOr<void> _onStartTripRecording(StartTripRecordingEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update trip in local list
      final index = _trips.indexWhere((trip) => trip.id == event.trip.id);
      if (index != -1) {
        _trips[index] = event.trip.copyWith(
          startTime: DateTime.now(),
        );
      } else {
        // Add new trip if not found
        _trips.add(event.trip.copyWith(
          startTime: DateTime.now(),
        ));
      }
      
      emit(TripRecordingStarted());
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao iniciar o registro da viagem: ${e.toString()}'));
    }
  }

  FutureOr<void> _onStopTripRecording(StopTripRecordingEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update trip in local list
      final index = _trips.indexWhere((trip) => trip.id == event.trip.id);
      if (index != -1) {
        final startTime = _trips[index].startTime;
        final endTime = DateTime.now();
        
        if (startTime != null) {
          final durationMinutes = endTime.difference(startTime).inMinutes;
          
          _trips[index] = event.trip.copyWith(
            endTime: endTime,
            duration: durationMinutes,
            // Example calculated values
            distance: 25.0,
            averageSpeed: 30.0,
            maxSpeed: 55.0,
          );
        }
      }
      
      emit(TripRecordingStopped());
      emit(TripsLoaded(trips: _trips));
    } catch (e) {
      emit(TripError(message: 'Falha ao parar o registro da viagem: ${e.toString()}'));
    }
  }

  FutureOr<void> _onDeletePhoto(DeletePhotoEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Remove from local list
      _photos.removeWhere((photo) => photo.id == event.photoId);
      
      emit(PhotoDeleted());
      emit(PhotosLoaded(photos: _photos));
    } catch (e) {
      emit(TripError(message: 'Falha ao excluir a foto: ${e.toString()}'));
    }
  }
}
