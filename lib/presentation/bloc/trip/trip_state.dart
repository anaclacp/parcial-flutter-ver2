import 'package:equatable/equatable.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/photo.dart';
import '../../../domain/entities/fuel_record.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripsLoaded extends TripState {
  final List<Trip> trips;

  const TripsLoaded({required this.trips});

  @override
  List<Object?> get props => [trips];
}

class PhotosLoaded extends TripState {
  final List<Photo> photos;

  const PhotosLoaded({required this.photos});

  @override
  List<Object?> get props => [photos];
}

class FuelRecordsLoaded extends TripState {
  final List<FuelRecord> fuelRecords;

  const FuelRecordsLoaded({required this.fuelRecords});

  @override
  List<Object?> get props => [fuelRecords];
}

class TripCreated extends TripState {}

class TripUpdated extends TripState {}

class TripDeleted extends TripState {}

class TripRecordingStarted extends TripState {}

class TripRecordingStopped extends TripState {}

class FuelRecordAdded extends TripState {}

class FuelRecordDeleted extends TripState {}

class PhotoDeleted extends TripState {}

class TripError extends TripState {
  final String message;

  const TripError({required this.message});

  @override
  List<Object?> get props => [message];
}
