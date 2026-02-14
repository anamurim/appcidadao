import 'package:flutter/foundation.dart';
import '../../../core/modelos/usuario.dart';
import '../../../core/repositorios/usuario_repositorio.dart';
import '../../../core/repositorios/usuario_repositorio_local.dart';

/// Controlador do perfil do usuário.
///
/// Carrega e atualiza os dados do usuário logado,
/// notificando a UI sobre qualquer mudança.
class UsuarioController extends ChangeNotifier {
  final UsuarioRepositorio _repositorio;

  UsuarioController({UsuarioRepositorio? repositorio})
      : _repositorio = repositorio ?? UsuarioRepositorioLocal();

  Usuario? _usuario;
  bool _isLoading = false;

  // --- Getters ---
  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;

  /// Atalhos para dados exibidos frequentemente na UI.
  String get nome => _usuario?.nome ?? 'Usuário';
  String get email => _usuario?.email ?? '';
  String get conta => _usuario?.conta ?? '';
  String get avatar => _usuario?.avatar ?? '';

  /// Carrega o usuário atual do repositório.
  Future<void> carregarUsuario() async {
    _isLoading = true;
    notifyListeners();

    try {
      _usuario = await _repositorio.getUsuarioAtual();
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Atualiza os dados do perfil.
  Future<void> atualizarUsuario(Usuario novoUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repositorio.atualizarUsuario(novoUsuario);
      _usuario = novoUsuario;
    } catch (e) {
      debugPrint('Erro ao atualizar usuário: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
