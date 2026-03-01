import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Controlador de autenticação com Firebase Auth.
///
/// Gerencia login, cadastro, recuperação de senha e logout.
/// Em caso de falha do Firebase (ex: sem internet), informa o erro
/// mas permite acesso em modo offline (simulado).
class AutenticacaoController extends ChangeNotifier {
  final FirebaseAuth _auth;

  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _modoOffline = false;
  String? _errorMessage;

  AutenticacaoController({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance {
    // Escuta mudanças no estado de autenticação do Firebase
    _auth.authStateChanges().listen((User? user) {
      _isLoggedIn = user != null;
      notifyListeners();
    });
  }

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get modoOffline => _modoOffline;
  String? get errorMessage => _errorMessage;

  /// Retorna o usuário atual do Firebase Auth, ou null.
  User? get usuarioAtual => _auth.currentUser;

  /// UID do usuário logado, ou null.
  String? get uid => _auth.currentUser?.uid;

  /// Realiza o login com email e senha via Firebase Auth.
  ///
  /// Se o Firebase falhar (sem internet, configuração inválida, etc.),
  /// informa o erro e habilita modo offline.
  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      _isLoggedIn = true;
      _modoOffline = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _traduzirErroAuth(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      // Firebase não inicializado ou sem internet
      debugPrint('⚠️ Firebase Auth indisponível: $e');
      _errorMessage =
          'Sem conexão com o servidor. Entrando em modo offline.';
      _modoOffline = true;
      _isLoggedIn = true; // Permite acesso em modo offline
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  /// Cria nova conta com email e senha via Firebase Auth.
  Future<bool> cadastrar(String email, String senha,
      {String? nome}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      // Atualiza o displayName se fornecido
      if (nome != null && nome.isNotEmpty) {
        await credencial.user?.updateDisplayName(nome);
      }

      _isLoggedIn = true;
      _modoOffline = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _traduzirErroAuth(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('⚠️ Firebase Auth indisponível para cadastro: $e');
      _errorMessage =
          'Sem conexão com o servidor. Não é possível criar conta offline.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Envia email de recuperação de senha via Firebase Auth.
  Future<bool> recuperarSenha(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _traduzirErroAuth(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Sem conexão. Tente novamente mais tarde.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Realiza o logout do usuário.
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // Ignora erros de sign out (offline)
    }
    _isLoggedIn = false;
    _modoOffline = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa mensagens de erro.
  void limparErro() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Traduz os códigos de erro do Firebase Auth para português.
  String _traduzirErroAuth(String codigo) {
    switch (codigo) {
      case 'user-not-found':
        return 'Nenhuma conta encontrada com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-email':
        return 'E-mail inválido. Verifique e tente novamente.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Contate o suporte.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde e tente novamente.';
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro ao autenticar. Código: $codigo';
    }
  }
}
