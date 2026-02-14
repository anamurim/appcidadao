import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';
import '../../../../funcionalidades/reportes/dominio/entidades/media_item.dart';

/// Reporte de estacionamento irregular / infração de trânsito.
///
/// Tipos: Fila Dupla, Vaga de Idoso/PNE, Guia Rebaixada, Calçada,
/// Ponto de Ônibus, Ciclovia, Outro.
class ReporteEstacionamento extends ReporteBase {
  final String tipoInfracao;
  final String? placaVeiculo;

  ReporteEstacionamento({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoInfracao,
    this.placaVeiculo,
  });

  @override
  String get tipoReporte => 'estacionamento';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoInfracao'] = tipoInfracao;
    map['placaVeiculo'] = placaVeiculo;
    return map;
  }

  factory ReporteEstacionamento.fromMap(Map<String, dynamic> map) {
    return ReporteEstacionamento(
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
      tipoInfracao: map['tipoInfracao'] as String,
      placaVeiculo: map['placaVeiculo'] as String?,
    );
  }
}
