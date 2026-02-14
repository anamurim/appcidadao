import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';

/// Reporte de problema em semáforo.
///
/// Tipos: Apagado, Piscando, Luzes Queimadas, Sincronia Incorreta,
/// Poste Danificado, Outro.
class ReporteSemaforo extends ReporteBase {
  final String tipoProblema;

  ReporteSemaforo({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoProblema,
  });

  @override
  String get tipoReporte => 'semaforo';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoProblema'] = tipoProblema;
    return map;
  }

  factory ReporteSemaforo.fromMap(Map<String, dynamic> map) {
    return ReporteSemaforo(
      id: map['id'] as String,
      endereco: map['endereco'] as String,
      pontoReferencia: map['pontoReferencia'] as String?,
      descricao: map['descricao'] as String,
      midias:
          (map['midias'] as List<dynamic>?)
              ?.map((m) => MediaItem.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      status: ReporteStatus.values.byName(map['status'] as String),
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      tipoProblema: map['tipoProblema'] as String,
    );
  }
}
