// lib/presentation/bloc/auth/auth_state.dart

import 'package:equatable/equatable.dart';
// MUDANÇA CRUCIAL: Importamos o usuário do Firebase Auth, não o do seu domínio.
// O BLoC de autenticação deve lidar diretamente com o objeto de usuário do Firebase.
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  // MUDANÇA CRUCIAL: Agora usamos o `User` do pacote `firebase_auth`.
  final User user;
  const Authenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

// NOVO: Estado para feedback visual após um registro bem-sucedido.
class RegistrationSuccessful extends AuthState {}

// MODIFICADO: Renomeado de PasswordResetSent para ser mais descritivo.
class PasswordResetEmailSent extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}