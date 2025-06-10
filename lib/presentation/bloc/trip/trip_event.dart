import 'package:equatable/equatable.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/fuel_record.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class LoadTripsEvent extends TripEvent {}

class LoadTripPhotosEvent extends TripEvent {
  final String tripId;

  const LoadTripPhotosEvent({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class LoadAllPhotosEvent extends TripEvent {}

class LoadFuelRecordsEvent extends TripEvent {}

class AddFuelRecordEvent extends TripEvent {
  final FuelRecord fuelRecord;

  const AddFuelRecordEvent({required this.fuelRecord});

  @override
  List<Object?> get props => [fuelRecord];
}

class DeleteFuelRecordEvent extends TripEvent {
  final String recordId;

  const DeleteFuelRecordEvent({required this.recordId});

  @override
  List<Object?> get props => [recordId];
}

class CreateTripEvent extends TripEvent {
  final Trip trip;

  const CreateTripEvent({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class UpdateTripEvent extends TripEvent {
  final Trip trip;

  const UpdateTripEvent({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class DeleteTripEvent extends TripEvent {
  final Trip trip;

  const DeleteTripEvent({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class StartTripRecordingEvent extends TripEvent {
  final Trip trip;

  const StartTripRecordingEvent({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class StopTripRecordingEvent extends TripEvent {
  final Trip trip;

  const StopTripRecordingEvent({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class DeletePhotoEvent extends TripEvent {
  final String photoId;

  const DeletePhotoEvent({required this.photoId});

  @override
  List<Object?> get props => [photoId];
}

class LoadTripByIdEvent extends TripEvent {
  final String tripId;

  LoadTripByIdEvent(this.tripId);
}
