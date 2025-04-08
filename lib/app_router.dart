import 'package:flutter/material.dart';
import 'domain/entities/trip.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/auth/about_page.dart';
import 'presentation/pages/trips/trip_dashboard_page.dart';
import 'presentation/pages/trips/trip_detail_page.dart';
import 'presentation/pages/trips/photo_gallery_page.dart';
import 'presentation/pages/fuel/fuel_consumption_page.dart';
import 'presentation/pages/maintenance/maintenance_reminder_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/início':
        return MaterialPageRoute(
          builder: (_) => const TripDashboardPage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case '/registrar':
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );
      case '/esqueceu-senha':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
        );
      case '/sobre':
        return MaterialPageRoute(
          builder: (_) => const AboutPage(),
        );
      case '/viagem/detalhe':
        final trip = settings.arguments as Trip;
        return MaterialPageRoute(
          builder: (_) => TripDetailPage(trip: trip),
        );
      case '/trip/create':
        return MaterialPageRoute(
          builder: (_) => TripDetailPage(
            trip: Trip(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: 'Nova Viagem',
            ),
          ),
        );
      case '/trip/edit':
        final trip = settings.arguments as Trip;
        return MaterialPageRoute(
          builder: (_) => TripDetailPage(trip: trip),
        );
      case '/fotos':
        return MaterialPageRoute(
          builder: (_) => const PhotoGalleryPage(),
        );
      case '/combustível':
        return MaterialPageRoute(
          builder: (_) => const FuelConsumptionPage(),
        );
      case '/manutenção':
        return MaterialPageRoute(
          builder: (_) => const MaintenanceReminderPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Nenhuma rota definida para ${settings.name}'),
            ),
          ),
        );
    }
  }
}

