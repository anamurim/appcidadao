import '../modelos/usuario.dart';
import 'usuario_repositorio.dart';

/// Implementação local (em memória) do repositório de usuário.
///
/// Inicializa com um usuário mock para desenvolvimento.
class UsuarioRepositorioLocal implements UsuarioRepositorio {
  // Singleton
  static final UsuarioRepositorioLocal _instancia =
      UsuarioRepositorioLocal._interno();

  factory UsuarioRepositorioLocal() => _instancia;

  UsuarioRepositorioLocal._interno();

  Usuario _usuarioAtual = const Usuario(
    nome: 'Usuário',
    email: 'e-mail@gmail.com',
    conta: '12345-6',
    avatar:
        'https://ui-avatars.com/api/?name=Carlos+Silva&background=0066FF&color=fff',
  );

  @override
  Future<Usuario> getUsuarioAtual() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _usuarioAtual;
  }

  @override
  Future<void> atualizarUsuario(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _usuarioAtual = usuario;
  }
}
