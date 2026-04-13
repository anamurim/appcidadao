import 'package:flutter/foundation.dart';
import 'dart:async';
import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';
import '../repositorios/reporte_repositorio_firebase.dart';
import 'conectividade_service.dart';
import 'hive_service.dart';

/// Callback para notificar progresso de sincronização.
typedef OnSincProgress = void Function(int total, int enviados, String? erro);

/// Serviço de sincronização de reportes com retry automático e persistência.
///
/// Monitora conectividade e sincroniza reportes pendentes quando online.
/// Implementa backoff exponencial e persiste dados localmente.
class SincronizadorReporteService {
  static final SincronizadorReporteService _instancia =
      SincronizadorReporteService._interno();

  factory SincronizadorReporteService() => _instancia;
  SincronizadorReporteService._interno();

  final ReporteRepositorioFirebase _firebase = ReporteRepositorioFirebase();
  final HiveService _hive = HiveService();
  final ConectividadeService _conectividade = ConectividadeService();

  bool _sincronizando = false;
  int _tentativaFalha = 0;
  final int _maxTentativas = 3;
  Timer? _timerRetry;
  OnSincProgress? _onProgress;

  bool get sincronizando => _sincronizando;

  /// Inicializa o serviço: monitora conectividade e sincroniza ao restaurar.
  Future<void> inicializar() async {
    await _hive.inicializar();

    // Sincroniza reportes já salvos quando o app inicia
    await sincronizarPendentes();

    // Escuta mudanças de conectividade
    _conectividade.adicionarOuvinte((conectado) {
      if (conectado && !_sincronizando) {
        debugPrint('🌐 Conexão restaurada, sincronizando reportes...');
        _tentativaFalha = 0; // Reset counter
        syncronizarComRetry();
      }
    });
  }

  /// Define callback para receber progresso.
  void setOnProgress(OnSincProgress callback) {
    _onProgress = callback;
  }

  /// Sincroniza todos os reportes com status "pendente".
  Future<void> sincronizarPendentes() async {
    final reportesPendentes = await _hive.buscarReportesPendentes();

    if (reportesPendentes.isEmpty) {
      debugPrint('✅ Nenhum reporte pendente para sincronizar.');
      return;
    }

    debugPrint(
      '📤 Sincronizando ${reportesPendentes.length} reporte(s) pendente(s)...',
    );

    await syncronizarComRetry(reportesPendentes);
  }

  /// Sincroniza com retry automático e backoff exponencial.
  Future<void> syncronizarComRetry([
    List<ReporteBase>? reportesEspecificos,
  ]) async {
    if (_sincronizando) {
      debugPrint('⏳ Sincronização já em andamento.');
      return;
    }

    _sincronizando = true;

    try {
      final reportes = reportesEspecificos ?? await _hive.buscarReportesPendentes();

      if (reportes.isEmpty) {
        _sincronizando = false;
        return;
      }

      int enviados = 0;

      for (final reporte in reportes) {
        try {
          // Valida reporte antes de enviar
          _validarReporte(reporte);

          // Tenta enviar ao Firebase
          await _firebase.salvarReporte(reporte);

          // Remove de pendentes
          await _hive.removerReportePendente(reporte.id);
          enviados++;

          _onProgress?.call(reportes.length, enviados, null);
          debugPrint('✅ Reporte ${reporte.id} sincronizado.');
        } catch (e) {
          debugPrint('❌ Erro ao sincronizar ${reporte.id}: $e');
          _onProgress?.call(reportes.length, enviados, _extrairMensagemErro(e));
          _tentativaFalha++;

          // Não para a sincronização, tenta o próximo
          continue;
        }
      }

      if (enviados == reportes.length) {
        debugPrint('✅ Todos os reportes sincronizados com sucesso!');
        _tentativaFalha = 0;
      } else {
        debugPrint('⚠️ Sincronização parcial: $enviados/${reportes.length}');

        // Se ainda há pendentes e não excedeu max tentativas, agenda retry
        if (_tentativaFalha < _maxTentativas) {
          _agendarRetry();
        } else {
          debugPrint('❌ Máximo de tentativas atingido. Aguarde conexão melhorar.');
        }
      }
    } catch (e) {
      debugPrint('🔴 Erro crítico na sincronização: $e');
      _onProgress?.call(0, 0, 'Erro crítico: $_extrairMensagemErro(e)');
      _tentativaFalha++;

      if (_tentativaFalha < _maxTentativas) {
        _agendarRetry();
      }
    } finally {
      _sincronizando = false;
    }
  }

  /// Salva reporte localmente com status pendente.
  Future<void> salvarReporteLocal(ReporteBase reporte) async {
    reporte.status = ReporteStatus.pendente;
    await _hive.salvarReporte(reporte.id, reporte.toMap());
    debugPrint(
      '💾 Reporte ${reporte.id} salvo localmente (pendente sincronização).',
    );
  }

  /// Agenda retry com backoff exponencial.
  void _agendarRetry() {
    final delaySegundos = _calcularDelayBackoff(_tentativaFalha);
    debugPrint(
      '⏱️ Reagendando sincronização em ${delaySegundos}s '
      '(tentativa $_tentativaFalha/$_maxTentativas)...',
    );

    _timerRetry?.cancel();
    _timerRetry = Timer(Duration(seconds: delaySegundos), () {
      if (_conectividade.conectado) {
        syncronizarComRetry();
      }
    });
  }

  /// Calcula delay com backoff exponencial: 2^n segundos (mín 5s, máx 120s).
  int _calcularDelayBackoff(int tentativa) {
    final delay = (60 * (1 << tentativa)).clamp(5, 120);
    return delay;
  }

  /// Valida dados críticos do reporte antes de enviar.
  void _validarReporte(ReporteBase reporte) {
    if (reporte.id.isEmpty) {
      throw Exception('ID do reporte vazio');
    }
    if (reporte.endereco.isEmpty) {
      throw Exception('Endereço do reporte vazio');
    }
    if (reporte.descricao.isEmpty) {
      throw Exception('Descrição do reporte vazia');
    }
  }

  /// Extrai mensagem de erro de forma legível.
  String _extrairMensagemErro(Object e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('permission-denied')) {
        return 'Permissão negada. Faça login novamente.';
      }
      if (msg.contains('not-found')) {
        return 'Projeto Firebase não encontrado.';
      }
      if (msg.contains('deadline-exceeded')) {
        return 'Conexão lenta, aguarde...';
      }
      return msg.replaceAll('Exception: ', '');
    }
    return e.toString();
  }

  /// Cancela retry agendado.
  void cancelarRetry() {
    _timerRetry?.cancel();
    _timerRetry = null;
  }

  /// Libera recursos.
  void dispose() {
    cancelarRetry();
    _conectividade.dispose();
  }

  /// Obtém contagem de reportes pendentes.
  Future<int> obterContagemPendentes() async {
    final reportes = await _hive.buscarReportesPendentes();
    return reportes.length;
  }
}
