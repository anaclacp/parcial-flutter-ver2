import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../../../domain/entities/trip.dart';
// import '../../../domain/entities/photo.dart';
import '../../../domain/entities/fuel_record.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  // NOVO: Instâncias do Firebase. Não usaremos mais repositórios mockados.
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // MODIFICADO: O construtor agora inicializa as instâncias do Firebase.
  TripBloc({FirebaseFirestore? firestore, FirebaseAuth? auth}) 
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(TripInitial()) {
    
    // ... Seus outros handlers continuam registrados ...
    on<LoadTripsEvent>(_onLoadTrips);
    on<LoadTripPhotosEvent>(_onLoadTripPhotos);
    // on<LoadTripsEvent>(_onLoadTrips);
    // on<LoadTripPhotosEvent>(_onLoadTripPhotos);
    // on<LoadAllPhotosEvent>(_onLoadAllPhotos);
    // on<CreateTripEvent>(_onCreateTrip);
    // on<UpdateTripEvent>(_onUpdateTrip);
    // on<DeleteTripEvent>(_onDeleteTrip);
    // on<StartTripRecordingEvent>(_onStartTripRecording);
    // on<StopTripRecordingEvent>(_onStopTripRecording);
    // on<DeletePhotoEvent>(_onDeletePhoto);
    
    // MODIFICADOS: Handlers para FuelRecord agora usam Firebase.
    on<LoadFuelRecordsEvent>(_onLoadFuelRecords);
    on<AddFuelRecordEvent>(_onAddFuelRecord);
    on<DeleteFuelRecordEvent>(_onDeleteFuelRecord);
  }

  // MODIFICADO: Handler para adicionar registro de combustível.
  Future<void> _onAddFuelRecord(AddFuelRecordEvent event, Emitter<TripState> emit) async {
    // Pode-se emitir um estado de loading se a operação for longa, mas para adicionar
    // geralmente é rápido e o feedback de sucesso é suficiente.
    try {
      // 1. Converte o objeto FuelRecord para um Map usando o método que criamos.
      final recordMap = event.fuelRecord.toMap();

      // 2. Adiciona o Map à coleção 'fuel_records' no Firestore.
      // O Firestore cuidará de criar a coleção se ela não existir.
      await _firestore.collection('fuel_records').add(recordMap);

      // 3. Emite o estado de sucesso para a UI reagir (mostrar SnackBar).
      emit(FuelRecordAdded());
      
      // 4. Dispara um novo evento para recarregar a lista com o item recém-adicionado.
      add(LoadFuelRecordsEvent());
      
    } catch (e) {
      // Em caso de erro (ex: sem permissão, sem internet), emite o estado de erro.
      emit(TripError(message: 'Falha ao adicionar registro: ${e.toString()}'));
    }
  }

  // MODIFICADO: Handler para carregar os registros de combustível.
  // Isso já adianta o RF005 (exibição de dados).
  Future<void> _onLoadFuelRecords(LoadFuelRecordsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      // 1. Busca no Firestore os documentos da coleção 'fuel_records'.
      // 2. Filtra para pegar apenas os registros cujo 'userId' corresponde ao do usuário logado.
      final snapshot = await _firestore
          .collection('fuel_records')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true) // Ordena pelos mais recentes primeiro.
          .get();

      // 3. Converte cada documento (que é um Map) de volta para um objeto FuelRecord.
      final fuelRecords = snapshot.docs.map((doc) {
        return FuelRecord.fromMap(doc.data(), doc.id);
      }).toList();
      
      // 4. Emite o estado com a lista de registros carregada.
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

  // --- SEUS OUTROS HANDLERS MOCKADOS (DEIXEI COMO ESTAVAM) ---

  FutureOr<void> _onLoadTrips(LoadTripsEvent event, Emitter<TripState> emit) async { /* ... */ }
  FutureOr<void> _onLoadTripPhotos(LoadTripPhotosEvent event, Emitter<TripState> emit) async { /* ... */ }
  // ... e assim por diante para todos os outros handlers que ainda usam dados mockados.
}