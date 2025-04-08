import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart'; 
import 'package:intl/date_symbol_data_local.dart'; 
import 'presentation/bloc/auth/auth_bloc.dart'; 
import 'presentation/bloc/trip/trip_bloc.dart'; 
import 'presentation/bloc/maintenance/maintenance_bloc.dart'; 
import 'app_router.dart'; 
import 'dependency_injection.dart' as di; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('pt_BR', null);  
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider<TripBloc>(
          create: (context) => di.sl<TripBloc>(),
        ),
        BlocProvider<MaintenanceBloc>(
          create: (context) => di.sl<MaintenanceBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Motorcycle Diary',
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
