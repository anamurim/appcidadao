import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../modelos/media_item.dart';
import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';

/// Serviço de cache local persistente usando Hive.
///
/// Gerencia os boxes (tabelas) de armazenamento local:
/// - `reportes` — reportes salvos localmente
/// - `usuario` — dados do perfil do usuário
/// - `configuracoes` — preferências do app
/// - `pendentes` — rastreador de reportes pendentes de sincronização
class HiveService {
  static final HiveService _instancia = HiveService._interno();

  factory HiveService() => _instancia;
  HiveService._interno();

  static const String _boxReportes = 'reportes';
  static const String _boxUsuario = 'usuario';
  static const String _boxConfiguracoes = 'configuracoes';
  static const String _boxPendentes = 'reportes_pendentes';

  bool _inicializado = false;

  /// Inicializa o Hive e abre os boxes necessários.
  ///
  /// Deve ser chamado antes de qualquer operação de leitura/escrita.
  Future<void> inicializar() async {
    if (_inicializado) return;

    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxReportes);
    await Hive.openBox<Map>(_boxUsuario);
    await Hive.openBox(_boxConfiguracoes);
    await Hive.openBox<String>(_boxPendentes);

    _inicializado = true;
    debugPrint('💾 HiveService inicializado');
  }

  // ── Reportes ──

  /// Retorna o box de reportes.
  Box<Map> get reportesBox => Hive.box<Map>(_boxReportes);

  /// Salva um reporte no cache local.
  Future<void> salvarReporte(String id, Map<String, dynamic> dados) async {
    await reportesBox.put(id, dados);
  }

  /// Retorna todos os reportes do cache local.
  List<Map<String, dynamic>> listarReportes() {
    return reportesBox.values
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  /// Remove um reporte do cache local.
  Future<void> removerReporte(String id) async {
    await reportesBox.delete(id);
  }

  /// Limpa todos os reportes do cache.
  Future<void> limparReportes() async {
    await reportesBox.clear();
  }

  /// Marca um reporte como pendente de sincronização.
  Future<void> marcarComoPendente(String id) async {
    final pendentesBox = Hive.box<String>(_boxPendentes);
    await pendentesBox.put(id, id);
  }

  /// Remove reporte da fila de pendentes (quando sincronizado com sucesso).
  Future<void> removerReportePendente(String id) async {
    final pendentesBox = Hive.box<String>(_boxPendentes);
    await pendentesBox.delete(id);
  }

  /// Retorna lista de reportes pendentes de sincronização.
  ///
  /// Lê os IDs da fila de pendentes e reconstrói os objetos ReporteBase.
  Future<List<ReporteBase>> buscarReportesPendentes() async {
    final pendentesBox = Hive.box<String>(_boxPendentes);
    final pendentes = <ReporteBase>[];

    for (final id in pendentesBox.values) {
      final dados = reportesBox.get(id);
      if (dados != null) {
        try {
          final reporte = reconstruirReporte(
            Map<String, dynamic>.from(dados),
          );
          pendentes.add(reporte);
        } catch (e) {
          debugPrint(
            '⚠️ Erro ao reconstruir reporte $id: $e',
          );
        }
      }
    }

    return pendentes;
  }

  /// Limpa todos os reportes pendentes.
  Future<void> limparPendentes() async {
    final pendentesBox = Hive.box<String>(_boxPendentes);
    await pendentesBox.clear();
  }

  /// Reconstrói um ReporteBase genérico a partir de um mapa.
  ReporteBase reconstruirReporte(Map<String, dynamic> data) {
    return _ReporteGenerico(
      id: data['id'] as String? ?? '',
      endereco: data['endereco'] as String? ?? '',
      pontoReferencia: data['pontoReferencia'] as String?,
      descricao: data['descricao'] as String? ?? '',
      tipoReporteStr: data['tipoReporte'] as String? ?? 'desconhecido',
      midias: (data['midias'] as List<dynamic>?)
              ?.map((m) {
                if (m is Map<String, dynamic>) {
                  return MediaItem.fromMap(m);
                }
                return null;
              })
              .whereType<MediaItem>()
              .toList() ??
          [],
      status: parseStatus(data['status'] as String?),
      dataCriacao: data['dataCriacao'] != null
          ? DateTime.tryParse(data['dataCriacao'] as String) ?? DateTime.now()
          : DateTime.now(),
      dadosExtras: data,
    );
  }

  ReporteStatus parseStatus(String? status) {
    if (status == null || status.isEmpty) return ReporteStatus.pendente;
    try {
      return ReporteStatus.values.byName(status);
    } catch (_) {
      return ReporteStatus.pendente;
    }
  }

  // ── Usuário ──

  /// Retorna o box de usuário.
  Box<Map> get usuarioBox => Hive.box<Map>(_boxUsuario);

  /// Salva os dados do usuário.
  Future<void> salvarUsuario(Map<String, dynamic> dados) async {
    await usuarioBox.put('atual', dados);
  }

  /// Retorna os dados do usuário atual, ou null.
  Map<String, dynamic>? getUsuario() {
    final dados = usuarioBox.get('atual');
    if (dados == null) return null;
    return Map<String, dynamic>.from(dados);
  }

  // ── Configurações ──

  /// Retorna o box de configurações.
  Box get configBox => Hive.box(_boxConfiguracoes);

  /// Salva uma configuração.
  Future<void> setConfig(String chave, dynamic valor) async {
    await configBox.put(chave, valor);
  }

  /// Retorna uma configuração, ou o valor padrão.
  T getConfig<T>(String chave, T valorPadrao) {
    return configBox.get(chave, defaultValue: valorPadrao) as T;
  }
}

/// Implementação genérica de ReporteBase para desserialização do Hive.
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
}
