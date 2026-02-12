import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';

/// Reporte de problema com iluminação pública.
///
/// Tipos: Lâmpada Apagada, Lâmpada Acesa de Dia, Oscilando,
/// Poste Danificado, Luminária Quebrada, Outro.
class ReporteIluminacao extends ReporteBase {
  final String tipoProblema;
  final String? numeroPoste;

  ReporteIluminacao({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoProblema,
    this.numeroPoste,
  });

  @override
  String get tipoReporte => 'iluminacao';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoProblema'] = tipoProblema;
    map['numeroPoste'] = numeroPoste;
    return map;
  }

  factory ReporteIluminacao.fromMap(Map<String, dynamic> map) {
    return ReporteIluminacao(
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
      numeroPoste: map['numeroPoste'] as String?,
    );
  }
}
