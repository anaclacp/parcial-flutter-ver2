import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String _version = '1.0.0';
  final String _buildNumber = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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
            Text(
              'Versão  $_version (Compilação  $_buildNumber)',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 40),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o aplicativo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'O Diário do Motociclista é um aplicativo completo, criado para entusiastas de motocicletas acompanharem suas jornadas, gerenciarem cronogramas de manutenção e registrarem o consumo de combustível. Seja você um piloto do dia a dia ou um viajante de longas distâncias, este app ajuda a manter um registro detalhado das suas experiências com a motocicleta. Inspirado no aplicativo novo Yamaha-Connected',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGray,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time de desenvolvimento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(height: 12),
                    _TeamMemberTile(
                      name: 'Ana Clara',
                      role: 'Desenvolvedor Full Stack',
                    ),
                    _TeamMemberTile(
                      name: 'Paulo Costa',
                      role: 'Desenvolvedor Full Stack',
                    )
                  ],
                ),
              ),
            ),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entre em contato',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, color: AppColors.primaryColor),
                        SizedBox(width: 12),
                        Text(
                          'suporte@diariodomotociclista.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.language_outlined, color: AppColors.primaryColor),
                        SizedBox(width: 12),
                        Text(
                          'www.diariodomotociclista.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '© 2025 Diário do Motociclista. Todos os direitos reservados.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  final String name;
  final String role;

  const _TeamMemberTile({
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightGray,
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
