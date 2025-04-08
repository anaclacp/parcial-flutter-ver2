import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

void _resetPassword() {
  if (_formKey.currentState!.validate()) {
    // Inicia o loading (antes do async gap, geralmente seguro)
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () { 

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mostra a mensagem de sucesso (agora seguro)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent. Please check your inbox.'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navega de volta (agora seguro)
        Navigator.of(context).pop();
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text(
                  'Redefinir Sua Senha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite seu endereço de e-mail e enviaremos instruções para redefinir sua senha.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mediumGray,
                  ),
                ),
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
                AppButton(
                  text: 'Enviar Instruções de Redefinição',
                  onPressed: _resetPassword,
                  type: ButtonType.primary,
                  icon: Icons.send,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Lembrou sua senha? ",
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
    );
  }
}
