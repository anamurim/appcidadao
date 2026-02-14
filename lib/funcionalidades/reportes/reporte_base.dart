import 'media_item.dart';
import 'reporte_status.dart';

/// Classe base abstrata para todos os tipos de reporte urbano.
///
/// Contém os campos comuns a qualquer reporte: localização, descrição,
/// mídias anexadas, status e data de criação.
abstract class ReporteBase {
  final String id;
  final String endereco;
  final String? pontoReferencia;
  final String descricao;
  final List<MediaItem> midias;
  ReporteStatus status;
  final DateTime dataCriacao;

  ReporteBase({
    required this.id,
    required this.endereco,
    this.pontoReferencia,
    required this.descricao,
    List<MediaItem>? midias,
    this.status = ReporteStatus.pendente,
    DateTime? dataCriacao,
  })  : midias = midias ?? [],
        dataCriacao = dataCriacao ?? DateTime.now();

  /// Tipo do reporte, implementado por cada subclasse.
  /// Ex: 'interferencia', 'semaforo', 'veiculo', etc.
  String get tipoReporte;

  /// Serializa os campos base para um Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipoReporte': tipoReporte,
      'endereco': endereco,
      'pontoReferencia': pontoReferencia,
      'descricao': descricao,
      'midias': midias.map((m) => m.toMap()).toList(),
      'status': status.name,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }
}
