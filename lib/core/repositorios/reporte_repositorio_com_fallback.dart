import 'package:flutter/foundation.dart';
import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';
import 'reporte_repositorio.dart';
import 'reporte_repositorio_firebase.dart';
import 'reporte_repositorio_local.dart';

/// Callback para notificar a UI sobre falhas de conexão.
typedef OnFalhaConexao = void Function(String mensagem);

/// Repositório wrapper que tenta usar Firebase e, em caso de falha,
/// automaticamente troca para o repositório local (fallback).
///
/// Implementa tratamento de erro com mais contexto, permitindo
/// distinguir entre problemas de autenticação, permissão e conexão.
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

  /// Executa a operação Firebase com tratamento de erro detalhado.
  /// Se falhar, troca para local e notifica com mensagem específica.
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
      final mensagem = _extrairMensagemErro(e);
      debugPrint(
        '⚠️ Firebase falhou: $e\n'
        'Mensagem extraída: $mensagem\n'
        'Usando repositório local como fallback.',
      );

      _usandoLocal = true;
      _onFalha?.call(mensagem);

      // Tenta usar local como backup
      try {
        return await operacao(_local);
      } catch (e2) {
        debugPrint(
          '❌ Fallback para local também falhou: $e2',
        );
        rethrow;
      }
    }
  }

  /// Extrai mensagem de erro legível e específica.
  String _extrairMensagemErro(Object e) {
    final msg = e.toString();

    // Autenticação
    if (msg.contains('user-not-authenticated')) {
      return '❌ Você precisa fazer login para enviar reportes.';
    }

    // Permissão
    if (msg.contains('permission-denied')) {
      return '❌ Permissão negada. Verifique as regras do Firestore ou refaça login.';
    }

    // Usuário não encontrado
    if (msg.contains('not-found') || msg.contains('not-authorized')) {
      return '❌ Usuário não encontrado. Tente fazer login novamente.';
    }

    // Timeout/Conexão lenta
    if (msg.contains('deadline-exceeded') || msg.contains('timeout')) {
      return '⏱️ Conexão lenta. Seus dados serão sincronizados quando a conexão melhorar.';
    }

    // Sem internet
    if (msg.contains('network') || msg.contains('no internet')) {
      return '📡 Sem conexão. Dados salvos localmente.';
    }

    // Validação
    if (msg.contains('ArgumentError') || msg.contains('vazio')) {
      return '❌ Dados incompletos. Verifique o formulário.';
    }

    // Genérico
    return '⚠️ Erro ao sincronizar. Tentando novamente...';
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
    debugPrint('🔄 Tentando reconectar ao Firebase...');
  }
}
