import 'package:get_it/get_it.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/trip/trip_bloc.dart';
import 'presentation/bloc/maintenance/maintenance_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => TripBloc());
  sl.registerFactory(() => MaintenanceBloc());

  // No repositories, data sources, or external dependencies needed
  // for the simplified non-Firebase implementation
}
