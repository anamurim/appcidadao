import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/media_item.dart';
import '../../../../core/modelos/reporte_status.dart';

/// Reporte de veículo quebrado/abandonado na via pública.
///
/// Tipos: Carro, Moto, Caminhão, Ônibus, Outro.
class ReporteVeiculo extends ReporteBase {
  final String tipoVeiculo;
  final String placa;
  final String? marca;
  final String? modelo;
  final String? cor;
  final String? nomeContato;
  final String? telefone;
  final String? email;

  ReporteVeiculo({
    required super.id,
    required super.endereco,
    super.pontoReferencia,
    required super.descricao,
    super.midias,
    super.status,
    super.dataCriacao,
    required this.tipoVeiculo,
    required this.placa,
    this.marca,
    this.modelo,
    this.cor,
    this.nomeContato,
    this.telefone,
    this.email,
  });

  @override
  String get tipoReporte => 'veiculo';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['tipoVeiculo'] = tipoVeiculo;
    map['placa'] = placa;
    map['marca'] = marca;
    map['modelo'] = modelo;
    map['cor'] = cor;
    map['nomeContato'] = nomeContato;
    map['telefone'] = telefone;
    map['email'] = email;
    return map;
  }

  factory ReporteVeiculo.fromMap(Map<String, dynamic> map) {
    return ReporteVeiculo(
      id: map['id'] as String,
      endereco: map['endereco'] as String,
      pontoReferencia: map['pontoReferencia'] as String?,
      descricao: map['descricao'] as String,
      midias: (map['midias'] as List<dynamic>?)
              ?.map((m) => MediaItem.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      status: ReporteStatus.values.byName(map['status'] as String),
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      tipoVeiculo: map['tipoVeiculo'] as String,
      placa: map['placa'] as String,
      marca: map['marca'] as String?,
      modelo: map['modelo'] as String?,
      cor: map['cor'] as String?,
      nomeContato: map['nomeContato'] as String?,
      telefone: map['telefone'] as String?,
      email: map['email'] as String?,
    );
  }
}
