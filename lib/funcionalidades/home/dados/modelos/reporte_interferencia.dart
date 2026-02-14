import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../../reportes/dominio/entidades/reporte_status.dart';

/// Reporte de interferência na via pública.
///
/// Tipos: Buraco na Via, Lixo/Entulho, Árvore Caída, Calçada Danificada,
/// Obstrução de Via, Bueiro Aberto/Quebrado, Outro.
class ReporteInterferencia extends ReporteBase {
  final String tipoInterferencia;
  final String? nomeContato;
  final String? emailContato;

  ReporteInterferencia({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoInterferencia,
    this.nomeContato,
    this.emailContato,
  });

  @override
  String get tipoReporte => 'interferencia';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoInterferencia'] = tipoInterferencia;
    map['nomeContato'] = nomeContato;
    map['emailContato'] = emailContato;
    return map;
  }

  factory ReporteInterferencia.fromMap(Map<String, dynamic> map) {
    return ReporteInterferencia(
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
      tipoInterferencia: map['tipoInterferencia'] as String,
      nomeContato: map['nomeContato'] as String?,
      emailContato: map['emailContato'] as String?,
    );
  }
}
