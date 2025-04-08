import 'package:flutter/material.dart';

class AppColors {
  // Primary color
  static const Color primaryColor = Color(0xFF9C27B0); // Roxo padrão Material

  // Secondary color (Roxo mais escuro ou Cinza Chumbo)
  static const Color secondaryColor = Color(0xFF6A1B9A); // Roxo mais escuro
  // Alternativa: static const Color secondaryColor = Color(0xFF37474F); // Cinza Chumbo

  // Accent color (Azul Ciano ou Rosa Vibrante)
  static const Color accentColor = Color(0xFF00BCD4); // Ciano
  // Alternativa: static const Color accentColor = Color(0xFFE91E63); // Rosa

  // Neutral colors (Seus nomes, valores padrão ou ajustados)
  static const Color darkGray = Colors.black; // Ou 0xFF121212 para tema escuro
  static const Color mediumGray = Color(0xFF9E9E9E); // Cinza Médio para textos secundários
  static const Color lightGray = Color(0xFFFAFAFA); // Fundo muito claro
  static const Color white = Color(0xFFFFFFFF);

  // Additional utility colors (Padrão)
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF03A9F4); // Azul claro (distinto do accent Ciano)
}
