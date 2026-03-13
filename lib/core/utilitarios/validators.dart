/// Validadores reutilizáveis para formulários do App Cidadão.
///
/// Cada função retorna `null` quando o valor é válido
/// ou uma mensagem de erro em português quando inválido.
class Validators {
  Validators._();

  /// Valida que o campo não está vazio.
  static String? campoObrigatorio(String? valor, [String? nomeCampo]) {
    if (valor == null || valor.trim().isEmpty) {
      return nomeCampo != null
          ? 'Informe $nomeCampo'
          : 'Este campo é obrigatório';
    }
    return null;
  }

  /// Valida formato de e-mail.
  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail';
    }
    final regex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.\w{2,}$');
    if (!regex.hasMatch(valor.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  /// Valida CPF (11 dígitos, com ou sem máscara).
  static String? cpf(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o CPF';
    }
    final digits = valor.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) {
      return 'CPF inválido';
    }
    // Validação dos dígitos verificadores
    if (!_validarDigitosCPF(digits)) {
      return 'CPF inválido';
    }
    return null;
  }

  /// Valida CEP (8 dígitos, com ou sem máscara).
  static String? cep(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o CEP';
    }
    final digits = valor.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    return null;
  }

  /// Valida telefone brasileiro (10 ou 11 dígitos, com ou sem máscara).
  static String? telefone(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o telefone';
    }
    final digits = valor.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) {
      return 'Telefone inválido';
    }
    return null;
  }

  /// Valida senha (mínimo 6 caracteres).
  static String? senha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe a senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  /// Valida confirmação de senha.
  static String? confirmarSenha(String? valor, String senhaOriginal) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme a senha';
    }
    if (valor != senhaOriginal) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // ────────────────────────────────────────────────────────
  // Helpers privados
  // ────────────────────────────────────────────────────────

  static bool _validarDigitosCPF(String digits) {
    // Primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(digits[i]) * (10 - i);
    }
    int resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;
    if (resto != int.parse(digits[9])) return false;

    // Segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(digits[i]) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;
    if (resto != int.parse(digits[10])) return false;

    return true;
  }
}
