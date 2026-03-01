import 'package:flutter/foundation.dart';
import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';
import 'reporte_repositorio.dart';
import 'reporte_repositorio_firebase.dart';
import 'reporte_repositorio_local.dart';

/// Callback para notificar a UI sobre falhas de conexão.
typedef OnFalhaConexao = void Function(String mensagem);

/// Repositório wrapper que tenta usar Firebase e, em caso de falha,
/// automaticamente troca para o repositório local.
///
/// Exibe uma mensagem de erro para o usuário quando o fallback acontece.
class ReporteRepositorioComFallback implements ReporteRepositorio {
  final ReporteRepositorioFirebase _firebase;
  final ReporteRepositorioLocal _local;
  final OnFalhaConexao? _onFalha;

  bool _usandoLocal = false;

  /// Indica se o repositório está operando em modo local (fallback).
  bool get usandoModoLocal => _usandoLocal;

  ReporteRepositorioComFallback({
    ReporteRepositorioFirebase? firebase,
    ReporteRepositorioLocal? local,
    OnFalhaConexao? onFalhaConexao,
  })  : _firebase = firebase ?? ReporteRepositorioFirebase(),
        _local = local ?? ReporteRepositorioLocal(),
        _onFalha = onFalhaConexao;

  /// Executa a operação Firebase. Se falhar, troca para local e notifica.
  Future<T> _executarComFallback<T>(
    Future<T> Function(ReporteRepositorio repo) operacao,
  ) async {
    // Se já está em modo local, usa direto
    if (_usandoLocal) {
      return operacao(_local);
    }

    try {
      return await operacao(_firebase);
    } catch (e) {
      debugPrint('⚠️ Firebase falhou, usando repositório local: $e');
      _usandoLocal = true;
      _onFalha?.call(
        'Sem conexão com o servidor. Seus dados estão sendo salvos localmente.',
      );
      return operacao(_local);
    }
  }

  @override
  Future<void> salvarReporte(ReporteBase reporte) =>
      _executarComFallback((repo) => repo.salvarReporte(reporte));

  @override
  Future<List<ReporteBase>> listarReportes() =>
      _executarComFallback((repo) => repo.listarReportes());

  @override
  Future<ReporteBase?> buscarReportePorId(String id) =>
      _executarComFallback((repo) => repo.buscarReportePorId(id));

  @override
  Future<void> atualizarStatus(String id, ReporteStatus novoStatus) =>
      _executarComFallback((repo) => repo.atualizarStatus(id, novoStatus));

  @override
  Future<void> removerReporte(String id) =>
      _executarComFallback((repo) => repo.removerReporte(id));

  /// Tenta reconectar ao Firebase. Útil para um botão "Tentar novamente".
  void tentarReconectar() {
    _usandoLocal = false;
  }
}
