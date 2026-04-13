import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Serviço de diagnóstico para identificar problemas de Firebase.
///
/// Verifica autenticação, permissões e configuração de Firestore.
/// Útil para debugging.
class DiagnosticoFirebaseService {
  static final DiagnosticoFirebaseService _instancia =
      DiagnosticoFirebaseService._interno();

  factory DiagnosticoFirebaseService() => _instancia;
  DiagnosticoFirebaseService._interno();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Executa diagnóstico completo e retorna relatório.
  Future<DiagnosticoRelatorio> diagnosticar() async {
    final relatorio = DiagnosticoRelatorio();

    // 1. Verifica autenticação
    relatorio.usuarioAutenticado = _auth.currentUser != null;
    relatorio.uid = _auth.currentUser?.uid;
    relatorio.email = _auth.currentUser?.email;

    if (!relatorio.usuarioAutenticado) {
      relatorio.problemas.add(
        '❌ Nenhum usuário autenticado. '
        'Faça login antes de enviar reportes.',
      );
    }

    // 2. Testa escrita no Firestore
    relatorio.permissaoEscrita = await _testarPermissaoEscrita();
    if (!relatorio.permissaoEscrita) {
      relatorio.problemas.add(
        '❌ Sem permissão para escrever em /reportes. '
        'Verifique as regras de segurança do Firestore.',
      );
    }

    // 3. Testa leitura no Firestore
    relatorio.permissaoLeitura = await _testarPermissaoLeitura();
    if (!relatorio.permissaoLeitura) {
      relatorio.problemas.add(
        '❌ Sem permissão para ler em /reportes. '
        'Verifique as regras de segurança do Firestore.',
      );
    }

    // 4. Verifica conexão de rede
    try {
      _firestore.settings;
      relatorio.firebaseConectado = true;
    } catch (e) {
      relatorio.firebaseConectado = false;
      relatorio.problemas.add(
        '❌ Sem conexão com Firebase (${e.toString()})',
      );
    }

    debugPrint('\n$relatorio\n');

    return relatorio;
  }

  /// Testa se usuário pode escrever em /reportes.
  Future<bool> _testarPermissaoEscrita() async {
    try {
      if (_auth.currentUser == null) {
        return false;
      }

      final doc = _firestore
          .collection('reportes')
          .doc('_teste_${DateTime.now().millisecondsSinceEpoch}');

      await doc.set({
        'teste': true,
        'dataCriacao': DateTime.now().toIso8601String(),
        'userId': _auth.currentUser!.uid,
      });

      // Remove arquivo de teste
      await doc.delete();

      return true;
    } catch (e) {
      debugPrint('Erro ao testar escrita: $e');
      return false;
    }
  }

  /// Testa se usuário pode ler em /reportes.
  Future<bool> _testarPermissaoLeitura() async {
    try {
      if (_auth.currentUser == null) {
        return false;
      }

      await _firestore
          .collection('reportes')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();

      return true;
    } catch (e) {
      debugPrint('Erro ao testar leitura: $e');
      return false;
    }
  }
}

/// Relatório de diagnóstico.
class DiagnosticoRelatorio {
  bool usuarioAutenticado = false;
  String? uid;
  String? email;
  bool permissaoEscrita = false;
  bool permissaoLeitura = false;
  bool firebaseConectado = false;
  List<String> problemas = [];

  bool get tudoOk =>
      usuarioAutenticado &&
      permissaoEscrita &&
      permissaoLeitura &&
      firebaseConectado &&
      problemas.isEmpty;

  @override
  String toString() {
    final buffer = StringBuffer('=== DIAGNÓSTICO FIREBASE ===\n');

    buffer.writeln('Autenticação:');
    buffer.writeln(
      '  ${usuarioAutenticado ? "✅" : "❌"} Usuário: '
      '${email ?? "não autenticado"}',
    );
    buffer.writeln('  UID: $uid');

    buffer.writeln('\nPermissões:');
    buffer.writeln('  ${permissaoEscrita ? "✅" : "❌"} Escrita em /reportes');
    buffer.writeln('  ${permissaoLeitura ? "✅" : "❌"} Leitura de /reportes');

    buffer.writeln('\nConexão:');
    buffer.writeln('  ${firebaseConectado ? "✅" : "❌"} Firebase conectado');

    if (problemas.isNotEmpty) {
      buffer.writeln('\n⚠️ PROBLEMAS DETECTADOS:');
      for (final problema in problemas) {
        buffer.writeln('  $problema');
      }
    } else {
      buffer.writeln('\n✅ Nenhum problema detectado!');
    }

    return buffer.toString();
  }
}
