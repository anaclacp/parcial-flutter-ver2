import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_event.dart';
import 'package:parcial/presentation/bloc/auth/auth_state.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_validator.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            PasswordResetRequested(email: _emailController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail de redefinição enviado! Verifique sua caixa de entrada.'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Esqueceu a Senha'),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Redefinir Sua Senha', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                  const SizedBox(height: 8),
                  const Text('Digite seu endereço de e-mail e enviaremos instruções para redefinir sua senha.', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
                  const SizedBox(height: 32),

                  AppTextField(
                    label: 'E-mail',
                    hint: 'Digite seu e-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: InputValidator.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 32),


                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Enviar Instruções de Redefinição',
                        onPressed: _resetPassword,
                        type: ButtonType.primary,
                        icon: Icons.send,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lembrou sua senha? ", style: TextStyle(color: AppColors.mediumGray)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Entrar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}