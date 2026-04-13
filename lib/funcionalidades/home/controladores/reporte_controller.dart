import 'package:flutter/foundation.dart';
import '../../../core/modelos/reporte_base.dart';
import '../../../core/modelos/reporte_status.dart';
import '../../../core/repositorios/reporte_repositorio.dart';
import '../../../core/repositorios/reporte_repositorio_com_fallback.dart';
import '../../../core/servicos/sincronizador_reporte_service.dart';
import 'dart:convert'; // Para usar jsonEncode/jsonDecode
import 'package:shared_preferences/shared_preferences.dart';

/// Controlador de reportes urbanos.
///
/// Gerencia a lista de reportes, submissão e atualização de status.
/// Notifica automaticamente a UI quando os dados mudam.
/// Integra sincronização automática via SincronizadorReporteService.
class ReporteController extends ChangeNotifier {
  final ReporteRepositorio _repositorio;
  final SincronizadorReporteService _sincronizador =
      SincronizadorReporteService();

  ReporteController({ReporteRepositorio? repositorio})
    : _repositorio = repositorio ?? ReporteRepositorioComFallback() {
    _inicializar();
    _carregarDadosDoDisco();
  }

  List<ReporteBase> _reportes = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _pendentesCount = 0;
  bool _sincronizando = false;

  // --- Getters ---
  List<ReporteBase> get reportes => List.unmodifiable(_reportes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalReportes => _reportes.length;
  int get reportesPendentes => _pendentesCount;
  bool get sincronizando => _sincronizando;

  /// Inicializa o sincronizador e carrega reportes.
  Future<void> _inicializar() async {
    await _sincronizador.inicializar();

    // Define callback de progresso
    _sincronizador.setOnProgress((total, enviados, erro) {
      _sincronizando = true;
      if (erro != null) {
        _errorMessage = erro;
      }
      notifyListeners();
    });

    // Atualiza contador de pendentes
    _atualizarContadorPendentes();

    // Carrega reportes inicialmente
    await carregarReportes();
  }

  // --- NOVO: Salvar no dispositivo ---
  Future<void> _salvarNoDisco() async {
    final prefs = await SharedPreferences.getInstance();
    // Converte a lista de objetos para uma String JSON
    final String dados = jsonEncode(_reportes.map((r) => r.toMap()).toList());
    await prefs.setString('historico_reportes', dados);
  }

  // --- NOVO: Carregar do dispositivo ---
  Future<void> _carregarDadosDoDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dados = prefs.getString('historico_reportes');
    if (dados != null) {
      final List decoded = jsonDecode(dados);
      // Aqui você deve converter o Map de volta para seu modelo de Reporte
      // _reportes = decoded.map((item) => ReporteBase.fromMap(item)).toList();
      notifyListeners();
    }
  }

  /// Carrega todos os reportes do repositório.
  Future<void> carregarReportes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reportes = List.from(await _repositorio.listarReportes());
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar reportes: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Submete um novo reporte e sincroniza automaticamente ou marca como pendente.
  Future<bool> submeterReporte(ReporteBase reporte) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Tenta enviar ao Firebase
      await _repositorio.salvarReporte(reporte);
      _reportes.insert(0, reporte); // Mais recente primeiro
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Se falhar, salva localmente como pendente
      debugPrint('⚠️ Falha ao enviar reporte: $e. Salvando localmente...');

      try {
        await _sincronizador.salvarReporteLocal(reporte);
        _reportes.insert(0, reporte);
        _errorMessage =
            'Reporte salvo localmente. Será enviado quando a conexão melhorar.';
        _atualizarContadorPendentes();
        _isLoading = false;
        notifyListeners();
        return true;
      } catch (e2) {
        _errorMessage =
            'Erro ao salvar reporte localmente: ${_extrairMensagem(e2)}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
  }

  /// Atualiza o status de um reporte existente.
  Future<void> atualizarStatus(String id, ReporteStatus novoStatus) async {
    try {
      await _repositorio.atualizarStatus(id, novoStatus);
      final index = _reportes.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reportes[index].status = novoStatus;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erro ao atualizar status: $e';
      notifyListeners();
    }
  }

  /// Remove um reporte pelo ID.
  Future<void> removerReporte(String id) async {
    try {
      await _repositorio.removerReporte(id);
      _reportes.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao remover reporte: $e';
      notifyListeners();
    }
  }

  /// Força sincronização manual de reportes pendentes.
  Future<void> forcarSincronizacao() async {
    await _sincronizador.syncronizarComRetry();
    await _atualizarContadorPendentes();
    notifyListeners();
  }

  /// Atualiza contador de reportes pendentes.
  Future<void> _atualizarContadorPendentes() async {
    _pendentesCount = await _sincronizador.obterContagemPendentes();
    notifyListeners();
  }

  /// Extrai mensagem legível de erro.
  String _extrairMensagem(Object e) {
    final msg = e.toString();
    if (msg.contains('permission-denied')) {
      return 'Permissão negada. Faça login novamente.';
    }
    if (msg.contains('not-found')) {
      return 'Projeto Firebase não encontrado.';
    }
    if (msg.contains('deadline-exceeded')) {
      return 'Conexão lenta. Tente novamente.';
    }
    return msg.replaceAll('Exception: ', '');
  }

  @override
  void dispose() {
    _sincronizador.dispose();
    super.dispose();
  }
}
