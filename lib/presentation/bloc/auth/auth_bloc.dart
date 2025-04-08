import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Example user data - in a real app, this would come from a repository
  final User _exampleUser = User(
    id: '1',
    name: 'Ana Clara',
    email: 'ana@gmail.com',
    phone: '+5516992502742',
  );

  AuthBloc() : super(Unauthenticated()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogoutEvent>(_onLogout);
  }

  FutureOr<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Simple validation - in a real app, this would be a server authentication
      if (event.email == 'ana@gmail.com' && event.password == '123456') {
        emit(Authenticated(user: _exampleUser));
      } else {
        emit(const AuthError(message: '"E-mail ou senha inválidos'));
      }
    } catch (e) {
      emit(AuthError(message: 'Falha no login: ${e.toString()}'));
    }
  }

  FutureOr<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would create a new user in the database
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        email: event.email,
        phone: event.phone,
      );
      
      emit(Authenticated(user: newUser));
    } catch (e) {
      emit(AuthError(message: 'Falha no registro: ${e.toString()}'));
    }
  }

  FutureOr<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would send a password reset email
      emit(PasswordResetSent());
    } catch (e) {
      emit(AuthError(message: 'Falha na redefinição da senha: ${e.toString()}'));
    }
  }

  FutureOr<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Falha ao sair: ${e.toString()}'));
    }
  }
}
