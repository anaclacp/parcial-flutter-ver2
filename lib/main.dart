import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'core/constants/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart'; 
import 'presentation/bloc/trip/trip_bloc.dart';
import 'presentation/bloc/maintenance/maintenance_bloc.dart';
import 'app_router.dart';
import 'dependency_injection.dart' as di;

import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/trips/trip_dashboard_page.dart';
import 'presentation/widgets/common/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização de formatação de datas (pt_BR)
  await initializeDateFormatting('pt_BR', null);

  // Inicialização das dependências
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // MODIFICAÇÃO APLICADA AQUI
        BlocProvider<AuthBloc>(
          create: (BuildContext context) {
            final bloc = di.sl<AuthBloc>();
            bloc.add(CheckAuthStatusEvent());
            return bloc;
          },
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
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingIndicator(message: 'Verificando...'),
          );
        }

        if (snapshot.hasData) {
          return const TripDashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
