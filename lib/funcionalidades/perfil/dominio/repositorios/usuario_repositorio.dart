import '../entidades/usuario.dart';

/// Interface abstrata do repositório de usuário.
///
/// Define o contrato para operações sobre o perfil do usuário logado.
abstract class UsuarioRepositorio {
  /// Retorna o usuário atualmente logado.
  Future<Usuario> getUsuarioAtual();

  /// Atualiza os dados do perfil do usuário.
  Future<void> atualizarUsuario(Usuario usuario);
}
