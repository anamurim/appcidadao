import 'package:flutter/foundation.dart';
import '../../../core/modelos/reporte_base.dart';
import '../../../core/modelos/reporte_status.dart';
import '../../../core/repositorios/reporte_repositorio.dart';
import '../../../core/repositorios/reporte_repositorio_local.dart';

/// Controlador de reportes urbanos.
///
/// Gerencia a lista de reportes, submissão e atualização de status.
/// Notifica automaticamente a UI quando os dados mudam.
class ReporteController extends ChangeNotifier {
  final ReporteRepositorio _repositorio;

  ReporteController({ReporteRepositorio? repositorio})
      : _repositorio = repositorio ?? ReporteRepositorioLocal();

  List<ReporteBase> _reportes = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- Getters ---
  List<ReporteBase> get reportes => List.unmodifiable(_reportes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalReportes => _reportes.length;

  /// Carrega todos os reportes do repositório.
  Future<void> carregarReportes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reportes = List.from(await _repositorio.listarReportes());
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar reportes.';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Submete um novo reporte e adiciona à lista local.
  Future<bool> submeterReporte(ReporteBase reporte) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repositorio.salvarReporte(reporte);
      _reportes.insert(0, reporte); // Mais recente primeiro
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao enviar reporte.';
      _isLoading = false;
      notifyListeners();
      return false;
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
      _errorMessage = 'Erro ao atualizar status.';
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
      _errorMessage = 'Erro ao remover reporte.';
      notifyListeners();
    }
  }
}
