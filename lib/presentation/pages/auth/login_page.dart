import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_event.dart';
import 'package:parcial/presentation/bloc/auth/auth_state.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_validator.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // MODIFICADO: A função de login agora despacha um evento para o BLoC.
  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }
  
  void _forgotPassword() {
      // Pequena validação para não enviar campo vazio
      if (_emailController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Por favor, informe seu e-mail no campo correspondente para recuperar a senha.'),
                backgroundColor: AppColors.warning,
            ),
          );
          return;
      }
      context.read<AuthBloc>().add(PasswordResetRequested(email: _emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('E-mail de recuperação enviado! Verifique sua caixa de entrada.'),
                backgroundColor: AppColors.success,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(width: 120, height: 120, decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.motorcycle, size: 60, color: AppColors.white)),
                  const SizedBox(height: 24),
                  const Text('Diário do Motociclista', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                  const SizedBox(height: 8),
                  const Text('Entre na sua conta', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
                  const SizedBox(height: 40),
                  
                  AppTextField(
                    label: 'E-mail',
                    hint: 'Digite seu e-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: InputValidator.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Senha',
                    hint: 'Digite sua senha',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: InputValidator.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      // MODIFICADO: Chama a nova função _forgotPassword
                      onPressed: _forgotPassword,
                      child: const Text('Esqueceu a senha?'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // NOVO: Envolvemos o botão com um BlocBuilder para controlar o estado de loading.
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Entrar',
                        onPressed: _login,
                        type: ButtonType.primary,
                        icon: Icons.login,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta? ", style: TextStyle(color: AppColors.mediumGray)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/registrar');
                        },
                        child: const Text('Registrar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/sobre');
                    },
                    child: const Text('Sobre'),
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