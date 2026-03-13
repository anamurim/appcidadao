import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Serviço de cache local persistente usando Hive.
///
/// Gerencia os boxes (tabelas) de armazenamento local:
/// - `reportes` — reportes salvos localmente
/// - `usuario` — dados do perfil do usuário
/// - `configuracoes` — preferências do app
class HiveService {
  static final HiveService _instancia = HiveService._interno();

  factory HiveService() => _instancia;
  HiveService._interno();

  static const String _boxReportes = 'reportes';
  static const String _boxUsuario = 'usuario';
  static const String _boxConfiguracoes = 'configuracoes';

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
