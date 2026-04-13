import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../modelos/usuario.dart';
import 'usuario_repositorio.dart';

/// Implementação Firebase (Cloud Firestore) do repositório de usuário.
///
/// Os dados do perfil são armazenados na coleção 'usuarios',
/// indexados pelo UID do Firebase Auth.
class UsuarioRepositorioFirebase implements UsuarioRepositorio {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsuarioRepositorioFirebase({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
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
      avatar:
          user?.photoURL ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user?.displayName ?? 'U')}&background=0066FF&color=fff',
    );

    // Salva no Firestore para próximas consultas
    await _colecao.doc(_uid).set(novoUsuario.toMap());
    return novoUsuario;
  }

  Future<String> uploadAvatar(File imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('$_uid.jpg'); // Usa o UID do user para nomear o ficheiro

    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Future<void> atualizarUsuario(Usuario usuario) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Usamos .update para garantir que apenas os campos fornecidos sejam alterados
      // e o ID user.uid garante que estamos mexendo no documento do usuário logado.
      await _colecao.doc(user.uid).update(usuario.toMap());

      debugPrint('✅ Campos atualizados com sucesso para o UID: ${user.uid}');
    } catch (e) {
      // Se o documento não existir (erro raro), o update falha.
      // Caso queira que ele crie se não existir, usamos o set com merge:
      debugPrint(
        '⚠️ Erro ao atualizar (doc pode não existir), tentando merge...',
      );
      await _colecao
          .doc(_auth.currentUser!.uid)
          .set(usuario.toMap(), SetOptions(merge: true));
    }
  }
}
