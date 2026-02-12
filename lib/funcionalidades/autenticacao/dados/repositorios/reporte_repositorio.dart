import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';

/// Interface abstrata do repositório de reportes.
///
/// Define o contrato para operações CRUD sobre reportes urbanos.
/// Implementações concretas podem usar memória local, SQLite, API REST, etc.
abstract class ReporteRepositorio {
  /// Salva um novo reporte.
  Future<void> salvarReporte(ReporteBase reporte);

  /// Retorna todos os reportes, do mais recente ao mais antigo.
  Future<List<ReporteBase>> listarReportes();

  /// Busca um reporte pelo seu ID. Retorna null se não encontrado.
  Future<ReporteBase?> buscarReportePorId(String id);

  /// Atualiza o status de um reporte existente.
  Future<void> atualizarStatus(String id, ReporteStatus novoStatus);

  /// Remove um reporte pelo ID.
  Future<void> removerReporte(String id);
}
