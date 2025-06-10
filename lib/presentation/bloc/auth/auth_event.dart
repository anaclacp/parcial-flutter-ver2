// lib/presentation/bloc/auth/auth_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// NOVO: Evento para verificar o status de login na inicialização do app.
// Este é o evento que estava faltando e causando o erro no main.dart!
class CheckAuthStatusEvent extends AuthEvent {}

// MODIFICADO: Renomeado de LoginEvent para SignInRequested por clareza.
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

// MODIFICADO: Renomeado de RegisterEvent para RegisterRequested.
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  const RegisterRequested({required this.name, required this.email, required this.phone, required this.password});
  @override
  List<Object?> get props => [name, email, phone, password];
}

// MODIFICADO: Renomeado de ResetPasswordEvent para PasswordResetRequested.
class PasswordResetRequested extends AuthEvent {
  final String email;
  const PasswordResetRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

// MODIFICADO: Renomeado de LogoutEvent para SignOutRequested.
class SignOutRequested extends AuthEvent {}