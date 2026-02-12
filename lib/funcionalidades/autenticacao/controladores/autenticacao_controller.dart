import 'package:flutter/foundation.dart';

/// Controlador de autenticação.
///
/// Gerencia o estado de login/logout usando ChangeNotifier,
/// permitindo que a UI reaja automaticamente a mudanças.
class AutenticacaoController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  /// Realiza o login com email e senha.
  ///
  /// Simula uma chamada de rede com delay de 2 segundos.
  /// Pronto para ser conectado a um serviço de autenticação real.
  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulação de chamada de API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Substituir pela lógica real de autenticação
      // Ex: final response = await authService.login(email, senha);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Falha ao realizar login. Tente novamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Realiza o logout do usuário.
  void logout() {
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa mensagens de erro.
  void limparErro() {
    _errorMessage = null;
    notifyListeners();
  }
}
