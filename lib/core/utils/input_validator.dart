class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Por favor, insira um endereço de e-mail válido';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número de telefone é obrigatório';
    }
    
  final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Por favor, insira um número de telefone válido';
    }

    return null;
    }

    static String? validateConfirmPassword(String? value, String password) {
      if (value == null || value.isEmpty) {
        return 'Por favor, confirme sua senha';
      }

      if (value != password) {
        return 'As senhas não coincidem';
      }

      return null;
    }

    static String? validateNotEmpty(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        return '$fieldName é obrigatório';
      }

      return null;
    }

    static String? validateNumber(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        return '$fieldName é obrigatório';
      }

      if (double.tryParse(value) == null) {
        return 'Por favor, insira um número válido';
      }

      return null;
    }
}