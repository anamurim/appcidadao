import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// 🔍 Serviço de debug para verificar dados no Firestore
/// 
/// Uso:
/// ```dart
/// await FirestoreDebugServico.verificarReportes();
/// await FirestoreDebugServico.verificarUsuarioAtual();
/// ```
class FirestoreDebugServico {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// 📋 Exibe todos os reportes do usuário logado e retorna um summary
  static Future<String> verificarReportes() async {
    debugPrint('\n${'═' * 80}');
    debugPrint('🔍 VERIFICANDO REPORTES NO FIRESTORE');
    debugPrint('═' * 80);

    String resultado = '';

    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ Nenhum usuário logado!');
        return '❌ Nenhum usuário logado!';
      }

      debugPrint('👤 Usuário: ${user.email} (UID: ${user.uid})');
      debugPrint('─' * 80);

      // Query: todos os reportes do usuário
      final snapshot = await _firestore
          .collection('reportes')
          .where('userId', isEqualTo: user.uid)
          .orderBy('dataCriacao', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('📭 Nenhum reporte encontrado!');
        return '📭 Nenhum reporte encontrado!';
      } else {
        debugPrint('✅ Total de reportes: ${snapshot.docs.length}\n');
        resultado = '✅ ${snapshot.docs.length} reporte(s) encontrado(s):\n\n';

        for (int i = 0; i < snapshot.docs.length; i++) {
          final doc = snapshot.docs[i];
          final data = doc.data();

          debugPrint('━━━ REPORTE #${i + 1} ━━━');
          debugPrint('   ID: ${data['id']}');
          debugPrint('   Tipo: ${data['tipoReporte']}');
          debugPrint('   Status: ${data['status']}');
          debugPrint('   Endereço: ${data['endereco']}');
          debugPrint('   Descrição: ${data['descricao']}');
          debugPrint('   Data Criação: ${data['dataCriacao']}');

          resultado += '━━━ REPORTE #${i + 1} ━━━\n';
          resultado += 'ID: ${data['id']}\n';
          resultado += 'Tipo: ${data['tipoReporte']}\n';
          resultado += 'Endereço: ${data['endereco']}\n';

          // Exibe mídias
          final midias = data['midias'] as List<dynamic>?;
          if (midias != null && midias.isNotEmpty) {
            debugPrint('   📸 Mídias (${midias.length}):');
            resultado += '📸 Mídias (${midias.length}):\n';
            for (int j = 0; j < midias.length; j++) {
              final media = midias[j] as Map<String, dynamic>;
              debugPrint(
                '      [$j] Tipo: ${media['type']}, '
                'Nome: ${media['nomeArquivo']}',
              );
              debugPrint('          URL: ${media['url']}');
              resultado += '  [$j] ${media['nomeArquivo']}\n';
              resultado += '      URL: ${media['url']}\n';
            }
          } else {
            debugPrint('   📸 Sem mídias');
            resultado += '📸 Sem mídias\n';
          }

          resultado += '\n';
          debugPrint('');
        }
      }

      debugPrint('═' * 80 + '\n');
      return resultado;
    } catch (e) {
      debugPrint('❌ ERRO ao consultar reportes: $e\n');
      return '❌ ERRO: $e';
    }
  }

  /// 👤 Exibe dados do usuário logado
  static Future<void> verificarUsuarioAtual() async {
    debugPrint('\n${'═' * 80}');
    debugPrint('🔍 VERIFICANDO USUÁRIO NO FIRESTORE');
    debugPrint('═' * 80);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ Nenhum usuário logado!');
        return;
      }

      debugPrint('👤 Usuário Firebase Auth:');
      debugPrint('   UID: ${user.uid}');
      debugPrint('   Email: ${user.email}');
      debugPrint('   Display Name: ${user.displayName}');
      debugPrint('   Foto: ${user.photoURL}');
      debugPrint('   Email Verificado: ${user.emailVerified}');
      debugPrint('─' * 80);

      // Query: documento do usuário no Firestore
      final docSnapshot = await _firestore.collection('usuarios').doc(user.uid).get();

      if (!docSnapshot.exists) {
        debugPrint('❌ Perfil não encontrado no Firestore!');
      } else {
        final data = docSnapshot.data();
        debugPrint('✅ Perfil Firestore:');
        debugPrint('   Nome: ${data?['nome']}');
        debugPrint('   Email: ${data?['email']}');
        debugPrint('   Conta: ${data?['conta']}');
        debugPrint('   Telefone: ${data?['telefone']}');
        debugPrint('   CPF: ${data?['cpf']}');
        debugPrint('   CEP: ${data?['cep']}');
        debugPrint('   Endereço: ${data?['endereco']}');
        debugPrint('   Avatar: ${data?['avatar']}');
      }

      debugPrint('═' * 80 + '\n');
    } catch (e) {
      debugPrint('❌ ERRO ao consultar usuário: $e\n');
    }
  }

  /// 📊 Exibe estatísticas gerais
  static Future<void> verificarEstatisticas() async {
    debugPrint('\n${'═' * 80}');
    debugPrint('📊 ESTATÍSTICAS DO FIRESTORE');
    debugPrint('═' * 80);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ Nenhum usuário logado!');
        return;
      }

      // Total de reportes do usuário
      final reportesSnapshot = await _firestore
          .collection('reportes')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Reportes por status
      final statusMap = <String, int>{};
      for (final doc in reportesSnapshot.docs) {
        final status = doc.data()['status'] as String? ?? 'desconhecido';
        statusMap[status] = (statusMap[status] ?? 0) + 1;
      }

      // Total de mídias
      int totalMidias = 0;
      for (final doc in reportesSnapshot.docs) {
        final midias = doc.data()['midias'] as List<dynamic>? ?? [];
        totalMidias += midias.length;
      }

      debugPrint('📈 Seu perfil:');
      debugPrint('   Total de reportes: ${reportesSnapshot.docs.length}');
      debugPrint('   Total de mídias: $totalMidias');
      debugPrint('   Por status:');
      statusMap.forEach((status, count) {
        debugPrint('      • $status: $count');
      });

      debugPrint('═' * 80 + '\n');
    } catch (e) {
      debugPrint('❌ ERRO ao consultar estatísticas: $e\n');
    }
  }

  /// 🧹 Deleta TODOS os reportes do usuário (CUIDADO!)
  static Future<void> limparReportes({required bool confirmar}) async {
    if (!confirmar) {
      debugPrint('❌ Confirmação necessária para limpar dados!');
      return;
    }

    debugPrint('\n${'═' * 80}');
    debugPrint('🗑️  LIMPANDO REPORTES DO FIRESTORE');
    debugPrint('═' * 80);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ Nenhum usuário logado!');
        return;
      }

      final snapshot = await _firestore
          .collection('reportes')
          .where('userId', isEqualTo: user.uid)
          .get();

      debugPrint('🗑️  Deletando ${snapshot.docs.length} reporte(s)...');

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
        debugPrint('   ✅ ${doc.id} deletado');
      }

      debugPrint('✅ Limpeza concluída!');
      debugPrint('═' * 80 + '\n');
    } catch (e) {
      debugPrint('❌ ERRO ao limpar dados: $e\n');
    }
  }
}
