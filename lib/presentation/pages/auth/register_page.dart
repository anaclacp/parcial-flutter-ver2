import 'package:flutter/material.dart';
// NOVO: Imports para BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_bloc.dart';
import 'package:parcial/presentation/bloc/auth/auth_event.dart';
import 'package:parcial/presentation/bloc/auth/auth_state.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_validator.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }


  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
      if (state is Authenticated) { 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bem-vindo! Registro realizado com sucesso.'),
            backgroundColor: AppColors.success,
          ),
        );
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
          title: const Text('Criar Conta'),
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
                  const Text('Junte-se ao Diário do Motociclista', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                  const SizedBox(height: 8),
                  const Text('Crie uma conta para registrar suas viagens de moto', style: TextStyle(fontSize: 16, color: AppColors.mediumGray)),
                  const SizedBox(height: 32),
                  AppTextField(label: 'Nome completo', hint: 'Digite o seu nome completo', controller: _nameController, validator: InputValidator.validateName, prefixIcon: const Icon(Icons.person_outline)),
                  const SizedBox(height: 20),
                  AppTextField(label: 'E-mail', hint: 'Digite o seu e-mail', controller: _emailController, keyboardType: TextInputType.emailAddress, validator: InputValidator.validateEmail, prefixIcon: const Icon(Icons.email_outlined)),
                  const SizedBox(height: 20),
                  AppTextField(label: 'Número de telefone', hint: 'Digite seu número de telefone', controller: _phoneController, keyboardType: TextInputType.phone, validator: InputValidator.validatePhone, prefixIcon: const Icon(Icons.phone_outlined)),
                  const SizedBox(height: 20),
                  AppTextField(label: 'Senha', hint: 'Criar a senha', controller: _passwordController, obscureText: _obscurePassword, validator: InputValidator.validatePassword, prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: _togglePasswordVisibility)),
                  const SizedBox(height: 20),
                  AppTextField(label: 'Confirmar Senha', hint: 'Confirme sua senha', controller: _confirmPasswordController, obscureText: _obscureConfirmPassword, validator: (value) => InputValidator.validateConfirmPassword(value, _passwordController.text), prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: _toggleConfirmPasswordVisibility)),
                  const SizedBox(height: 32),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Criar conta',
                        onPressed: _register,
                        type: ButtonType.primary,
                        icon: Icons.person_add,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Já tem uma conta? ",
                        style: TextStyle(color: AppColors.mediumGray),
                      ),
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