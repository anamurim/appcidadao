import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';

/// Reporte de problema com sinalização de trânsito.
///
/// Tipos: Placa Danificada, Placa Faltando, Semáforo Queimado,
/// Faixa de Pedestres Apagada, Pintura de Solo Inexistente, Outro.
class ReporteSinalizacao extends ReporteBase {
  final String tipoSinalizacao;

  ReporteSinalizacao({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoSinalizacao,
  });

  @override
  String get tipoReporte => 'sinalizacao';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoSinalizacao'] = tipoSinalizacao;
    return map;
  }

  factory ReporteSinalizacao.fromMap(Map<String, dynamic> map) {
    return ReporteSinalizacao(
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
      tipoSinalizacao: map['tipoSinalizacao'] as String,
    );
  }
}
