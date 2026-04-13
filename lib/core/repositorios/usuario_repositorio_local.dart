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
    avatar:
        'https://ui-avatars.com/api/?name=Carlos+Silva&background=0066FF&color=fff',
    nome: 'Usuário',
    email: 'e-mail@email.com',
    conta: '12345-6',
    cpf: '000.000.000-00',
    telefone: '(12) 34567-8901',
    cep: '12345-678',
    endereco: 'Rua Exemplo, 123',
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
