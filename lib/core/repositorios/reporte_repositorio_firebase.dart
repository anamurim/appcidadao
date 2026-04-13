import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../modelos/media_item.dart';
import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';
import '../servicos/storage_servico.dart';
import 'reporte_repositorio.dart';

/// Implementação Firebase (Cloud Firestore) do repositório de reportes.
///
/// Salva e lê reportes da coleção 'reportes' no Firestore.
/// Cada reporte é filtrado pelo UID do usuário logado.
/// Integra upload automático de mídias para Android e Web.
class ReporteRepositorioFirebase implements ReporteRepositorio {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageServico _storage;

  ReporteRepositorioFirebase({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    StorageServico? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? StorageServico();

  /// Referência à coleção de reportes no Firestore.
  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('reportes');

  /// UID do usuário logado.
  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-authenticated',
        message: 'Usuário não está autenticado. Faça login para enviar reportes.',
      );
    }
    return user.uid;
  }

  @override
  Future<void> salvarReporte(ReporteBase reporte) async {
    // Validação crítica: usuário deve estar autenticado
    final userId = _uid; // Lança exceção se não autenticado

    // Validação de dados
    if (reporte.id.isEmpty) {
      throw ArgumentError('ID do reporte não pode estar vazio');
    }
    if (reporte.endereco.isEmpty) {
      throw ArgumentError('Endereço do reporte não pode estar vazio');
    }

    // ========================= UPLOAD DE MÍDIAS =========================
    // Faz upload de todas as mídias com filePath local antes de salvar
    final midiasAtualizadas = <MediaItem>[];
    
    for (final media in reporte.midias) {
      if (media.filePath != null && media.filePath!.isNotEmpty) {
        final arquivo = File(media.filePath!);
        
        // Verifica se arquivo existe (importante para Web)
        if (kIsWeb || arquivo.existsSync()) {
          debugPrint('📤 Fazendo upload de ${media.nomeArquivo ?? 'arquivo'}...');
          
          final urlRemota = await _storage.uploadArquivo(
            arquivo: arquivo,
            reporteId: reporte.id,
            nomeArquivo: media.nomeArquivo,
          );

          // Se upload bem-sucedido, atualiza o MediaItem com URL remota
          if (urlRemota != null) {
            midiasAtualizadas.add(
              MediaItem(
                filePath: media.filePath,
                url: urlRemota, // ← URL remota agora
                type: media.type,
                nomeArquivo: media.nomeArquivo,
              ),
            );
            debugPrint(
              '✅ Upload bem-sucedido: ${media.nomeArquivo ?? 'arquivo'}',
            );
          } else {
            // Se falhar, mantém o filePath local como fallback
            midiasAtualizadas.add(media);
            debugPrint(
              '⚠️ Upload falhou para ${media.nomeArquivo}, usando fallback local',
            );
          }
        } else {
          // Arquivo não existe, mantém como está
          midiasAtualizadas.add(media);
        }
      } else {
        // Sem filePath (já foi feito upload antes), mantém como está
        midiasAtualizadas.add(media);
      }
    }

    // Atualiza as mídias do reporte with URLs remotas
    reporte.midias.clear();
    reporte.midias.addAll(midiasAtualizadas);
    // ========================= FIM UPLOAD DE MÍDIAS =========================

    final dados = reporte.toMap();
    dados['userId'] = userId;
    dados['status'] = ReporteStatus.enviado.name;
    dados['dataSincronizacao'] = FieldValue.serverTimestamp();

    try {
      await _colecao.doc(reporte.id).set(dados);
      debugPrint(
        '✅ Reporte ${reporte.id} salvo no Firebase com sucesso.',
      );
    } on FirebaseException catch (e) {
      debugPrint(
        '❌ Erro Firebase ao salvar reporte: '
        'Code: ${e.code}, Message: ${e.message}',
      );

      // Re-lança com mensagem mais clara
      if (e.code == 'permission-denied') {
        throw FirebaseException(
          plugin: e.plugin,
          code: e.code,
          message:
              'Permissão negada ao salvar no Firestore. Verifique as regras de segurança.',
        );
      }
      rethrow;
    } catch (e) {
      debugPrint('❌ Erro desconhecido ao salvar reporte: $e');
      rethrow;
    }
  }

  @override
  Future<List<ReporteBase>> listarReportes() async {
    final userId = _uid;

    final snapshot = await _colecao
        .where('userId', isEqualTo: userId)
        .orderBy('dataCriacao', descending: true)
        .get();

    return snapshot.docs.map((doc) => _docParaReporte(doc.data())).toList();
  }

  @override
  Future<ReporteBase?> buscarReportePorId(String id) async {
    final doc = await _colecao.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return _docParaReporte(doc.data()!);
  }

  @override
  Future<void> atualizarStatus(String id, ReporteStatus novoStatus) async {
    final userId = _uid;

    // Verifica se o reporte pertence ao usuário
    final doc = await _colecao.doc(id).get();
    if (!doc.exists || doc.data()?['userId'] != userId) {
      throw Exception('Reporte não encontrado ou sem permissão de acesso');
    }

    await _colecao.doc(id).update({
      'status': novoStatus.name,
      'dataAtualizacao': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removerReporte(String id) async {
    final userId = _uid;

    // Verifica se o reporte pertence ao usuário
    final doc = await _colecao.doc(id).get();
    if (!doc.exists || doc.data()?['userId'] != userId) {
      throw Exception('Reporte não encontrado ou sem permissão de acesso');
    }

    await _colecao.doc(id).delete();
  }

  /// Converte um documento do Firestore em um [ReporteBase] genérico.
  ///
  /// Como o Firestore armazena JSON plano, recriamos um
  /// objeto genérico usando a classe [_ReporteGenerico].
  ReporteBase _docParaReporte(Map<String, dynamic> data) {
    return _ReporteGenerico(
      id: data['id'] as String? ?? '',
      endereco: data['endereco'] as String? ?? '',
      pontoReferencia: data['pontoReferencia'] as String?,
      descricao: data['descricao'] as String? ?? '',
      tipoReporteStr: data['tipoReporte'] as String? ?? 'desconhecido',
      midias: (data['midias'] as List<dynamic>?)
              ?.map((m) => MediaItem.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      status: _parseStatus(data['status'] as String?),
      dataCriacao: data['dataCriacao'] != null
          ? DateTime.tryParse(data['dataCriacao'] as String) ?? DateTime.now()
          : DateTime.now(),
      dadosExtras: data,
    );
  }

  ReporteStatus _parseStatus(String? status) {
    if (status == null) return ReporteStatus.pendente;
    try {
      return ReporteStatus.values.byName(status);
    } catch (_) {
      return ReporteStatus.pendente;
    }
  }
}

/// Implementação genérica de [ReporteBase] usada para deserializar
/// qualquer tipo de reporte vindo do Firestore.
///
/// Armazena os dados extras (campos específicos de cada subtipo)
/// no mapa [dadosExtras] para que possam ser exibidos na UI.
class _ReporteGenerico extends ReporteBase {
  final String tipoReporteStr;
  final Map<String, dynamic> dadosExtras;

  _ReporteGenerico({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    required this.tipoReporteStr,
    super.midias,
    super.status,
    super.dataCriacao,
    this.dadosExtras = const {},
  });

  @override
  String get tipoReporte => tipoReporteStr;

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    // Preserva campos extras do subtipo original
    dadosExtras.forEach((key, value) {
      if (!map.containsKey(key)) {
        map[key] = value;
      }
    });
    return map;
  }
}
