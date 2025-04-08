import 'package:flutter/material.dart';
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
  bool _isLoading = false;

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

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Inicia o loading (antes do async gap)
      setState(() {
        _isLoading = true;
      });

      // Simula a chamada da API
      Future.delayed(const Duration(seconds: 2), () { 

        // +++ ADICIONE A VERIFICAÇÃO 'mounted' AQUI +++
        if (mounted) {
          // Para o loading (agora seguro)
          setState(() {
            _isLoading = false;
          });

          // Navega para a home (agora seguro)
          Navigator.of(context).pushReplacementNamed('/início');
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.motorcycle,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Diário do Motociclista',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre na sua conta',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mediumGray,
                  ),
                ),
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
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/esqueceu-senha');
                    },
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Entrar',
                  onPressed: _login,
                  type: ButtonType.primary,
                  icon: Icons.login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tem uma conta? ",
                      style: TextStyle(color: AppColors.mediumGray),
                    ),
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
    );
  }
}
