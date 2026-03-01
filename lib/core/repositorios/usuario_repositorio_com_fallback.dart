import 'package:flutter/foundation.dart';
import '../modelos/usuario.dart';
import 'usuario_repositorio.dart';
import 'usuario_repositorio_firebase.dart';
import 'usuario_repositorio_local.dart';

/// Callback para notificar a UI sobre falhas de conexão.
typedef OnFalhaConexao = void Function(String mensagem);

/// Repositório wrapper que tenta usar Firebase e, em caso de falha,
/// automaticamente troca para o repositório local.
class UsuarioRepositorioComFallback implements UsuarioRepositorio {
  final UsuarioRepositorioFirebase _firebase;
  final UsuarioRepositorioLocal _local;
  final OnFalhaConexao? _onFalha;

  bool _usandoLocal = false;

  /// Indica se o repositório está operando em modo local (fallback).
  bool get usandoModoLocal => _usandoLocal;

  UsuarioRepositorioComFallback({
    UsuarioRepositorioFirebase? firebase,
    UsuarioRepositorioLocal? local,
    OnFalhaConexao? onFalhaConexao,
  })  : _firebase = firebase ?? UsuarioRepositorioFirebase(),
        _local = local ?? UsuarioRepositorioLocal(),
        _onFalha = onFalhaConexao;

  Future<T> _executarComFallback<T>(
    Future<T> Function(UsuarioRepositorio repo) operacao,
  ) async {
    if (_usandoLocal) {
      return operacao(_local);
    }

    try {
      return await operacao(_firebase);
    } catch (e) {
      debugPrint('⚠️ Firebase falhou, usando repositório local: $e');
      _usandoLocal = true;
      _onFalha?.call(
        'Sem conexão com o servidor. Usando dados locais.',
      );
      return operacao(_local);
    }
  }

  @override
  Future<Usuario> getUsuarioAtual() =>
      _executarComFallback((repo) => repo.getUsuarioAtual());

  @override
  Future<void> atualizarUsuario(Usuario usuario) =>
      _executarComFallback((repo) => repo.atualizarUsuario(usuario));

  /// Tenta reconectar ao Firebase.
  void tentarReconectar() {
    _usandoLocal = false;
  }
}
