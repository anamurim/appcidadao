import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelos/usuario.dart';
import 'usuario_repositorio.dart';

/// Implementação Firebase (Cloud Firestore) do repositório de usuário.
///
/// Os dados do perfil são armazenados na coleção 'usuarios',
/// indexados pelo UID do Firebase Auth.
class UsuarioRepositorioFirebase implements UsuarioRepositorio {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsuarioRepositorioFirebase({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('usuarios');

  String get _uid => _auth.currentUser?.uid ?? 'anonimo';

  @override
  Future<Usuario> getUsuarioAtual() async {
    final doc = await _colecao.doc(_uid).get();

    if (doc.exists && doc.data() != null) {
      return Usuario.fromMap(doc.data()!);
    }

    // Se o documento não existe ainda, cria com dados do Firebase Auth
    final user = _auth.currentUser;
    final novoUsuario = Usuario(
      nome: user?.displayName ?? 'Usuário',
      email: user?.email ?? '',
      conta: _uid.substring(0, 7),
      avatar: user?.photoURL ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.displayName ?? 'U')}&background=0066FF&color=fff',
    );

    // Salva no Firestore para próximas consultas
    await _colecao.doc(_uid).set(novoUsuario.toMap());
    return novoUsuario;
  }

  @override
  Future<void> atualizarUsuario(Usuario usuario) async {
    await _colecao.doc(_uid).set(usuario.toMap(), SetOptions(merge: true));
  }
}
