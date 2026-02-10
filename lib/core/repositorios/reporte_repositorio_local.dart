import '../modelos/reporte_base.dart';
import '../modelos/reporte_status.dart';
import 'reporte_repositorio.dart';

/// Implementação local (em memória) do repositório de reportes.
///
/// Armazena os reportes em uma lista durante a sessão do app.
/// Pronta para ser substituída por SQLite ou integração com API.
class ReporteRepositorioLocal implements ReporteRepositorio {
  // Singleton para manter os dados durante toda a sessão
  static final ReporteRepositorioLocal _instancia =
      ReporteRepositorioLocal._interno();

  factory ReporteRepositorioLocal() => _instancia;

  ReporteRepositorioLocal._interno();

  final List<ReporteBase> _reportes = [];

  @override
  Future<void> salvarReporte(ReporteBase reporte) async {
    // Simula um pequeno delay de rede/disco
    await Future.delayed(const Duration(milliseconds: 100));
    reporte.status = ReporteStatus.enviado;
    _reportes.insert(0, reporte); // Mais recente primeiro
  }

  @override
  Future<List<ReporteBase>> listarReportes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.unmodifiable(_reportes);
  }

  @override
  Future<ReporteBase?> buscarReportePorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _reportes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> atualizarStatus(String id, ReporteStatus novoStatus) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _reportes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reportes[index].status = novoStatus;
    }
  }

  @override
  Future<void> removerReporte(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _reportes.removeWhere((r) => r.id == id);
  }
}
