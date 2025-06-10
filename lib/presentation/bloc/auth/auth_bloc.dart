// lib/presentation/bloc/auth/auth_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
// NOVO: Imports do Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imports dos seus arquivos de evento e estado já atualizados
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthBloc({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthInitial()) { 

    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignIn);
    on<RegisterRequested>(_onRegister);
    on<PasswordResetRequested>(_onResetPassword);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        emit(Authenticated(user: userCredential.user!));
      } else {
        emit(const AuthError(message: 'Não foi possível verificar o usuário após o login.'));
      }

    } on FirebaseAuthException catch (e) {
      
      String errorMessage = 'Ocorreu um erro desconhecido.';
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'E-mail ou senha inválidos. Por favor, tente novamente.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta conta de usuário foi desativada.';
          break;
        case 'invalid-email':
          errorMessage = 'O formato do e-mail é inválido.';
          break;
        default:
          errorMessage = 'Falha no login. Verifique sua conexão e tente novamente.';
      }
      
      emit(AuthError(message: errorMessage));

    } catch (e) {
      emit(AuthError(message: 'Um erro inesperado ocorreu: ${e.toString()}'));
    }
  }

  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
          'name': event.name,
          'email': event.email,
          'phone': event.phone,
          'createdAt': Timestamp.now(),
        });
        // 3. Emite um estado de sucesso para a UI poder reagir (ex: mostrar SnackBar e navegar)
        emit(Authenticated(user: userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Ocorreu um erro no registro.'));
    } catch (e) {
      emit(AuthError(message: 'Um erro inesperado ocorreu: ${e.toString()}'));
    }
  }

  // MODIFICADO: Lógica de Logout real
  Future<void> _onSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    // Não precisa de AuthLoading para um logout rápido
    try {
      await _firebaseAuth.signOut();
      // O AuthWrapper também cuidará da navegação de volta para a tela de login.
    } catch (e) {
      emit(AuthError(message: 'Erro ao fazer logout: ${e.toString()}'));
    }
  }

  // MODIFICADO: Lógica real de recuperação de senha
  Future<void> _onResetPassword(PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(PasswordResetEmailSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Erro ao enviar e-mail.'));
    } catch (e) {
      emit(AuthError(message: 'Um erro inesperado ocorreu: ${e.toString()}'));
    }
  }
}