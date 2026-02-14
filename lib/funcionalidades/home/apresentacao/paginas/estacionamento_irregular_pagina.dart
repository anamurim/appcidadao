import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_estacionamento.dart';

class TelaEstacionamentoIrregular extends StatefulWidget {
  const TelaEstacionamentoIrregular({super.key});

  @override
  State<TelaEstacionamentoIrregular> createState() =>
      _TelaEstacionamentoIrregularState();
}

class _TelaEstacionamentoIrregularState
    extends State<TelaEstacionamentoIrregular> {
  final _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoInfracao;
  final _placaController = TextEditingController();
  final _enderecoEstacionamentoController = TextEditingController();
  final _pontoReferenciaEstacionamentoController = TextEditingController();
  final _descricaoEstacionamentoController = TextEditingController();

  final List<String> _tipoInfracoes = [
    'Fila Dupla',
    'Vaga de Idoso/PNE sem cartão',
    'Guia Rebaixada (Garagem)',
    'Calçada/Passeio',
    'Ponto de Ônibus',
    'Ciclovia/Ciclofaixa',
    'Outro - Especificar na descrição',
  ];

  final List<MediaItem> _selectedMediaItemsEstacionamento = <MediaItem>[];

  @override
  void dispose() {
    _placaController.dispose();
    _enderecoEstacionamentoController.dispose();
    _pontoReferenciaEstacionamentoController.dispose();
    _descricaoEstacionamentoController.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIcon: Icon(icon, color: AppCores.neonBlue),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppCores.neonBlue),
      ),
      filled: true,
      fillColor: AppCores.lightGray,
    );
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final reporte = ReporteEstacionamento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoEstacionamentoController.text,
        pontoReferencia:
            _pontoReferenciaEstacionamentoController.text.isNotEmpty
            ? _pontoReferenciaEstacionamentoController.text
            : null,
        descricao: _descricaoEstacionamentoController.text,
        midias: List.from(_selectedMediaItemsEstacionamento),
        tipoInfracao: _selecionaTipoInfracao!,
        placaVeiculo: _placaController.text.isNotEmpty
            ? _placaController.text
            : null,
      );

      await context.read<ReporteController>().submeterReporte(reporte);
      await context.read<ReporteController>().submeterReporte(reporte);

      debugPrint('--- Relatório de Estacionamento Irregular salvo ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Infração: ${reporte.tipoInfracao}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppCores.lightGray,
            title: const Text(
              'Denúncia Enviada',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'As autoridades de trânsito foram notificadas sobre a irregularidade.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppCores.neonBlue),
                ),
              ),
            ],
          ),
        );
        // Volta para a Home automaticamente
        Navigator.pop(context);
      }
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _selecionaTipoInfracao = null;
      _placaController.clear();
      _enderecoEstacionamentoController.clear();
      _pontoReferenciaEstacionamentoController.clear();
      _descricaoEstacionamentoController.clear();
      _selectedMediaItemsEstacionamento.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estacionamento Irregular')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecaoTitulo("Detalhes da Infração"),
              const SizedBox(height: 15),

              // Dropdown de Infração
              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Tipo de Irregularidade',
                  Icons.warning_amber_rounded,
                ),
                items: _tipoInfracoes
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selecionaTipoInfracao = val),
                validator: (val) => val == null ? 'Selecione a infração' : null,
              ),
              const SizedBox(height: 15),

              // Placa do Veículo
              TextFormField(
                controller: _placaController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Placa do Veículo (Se visível)',
                  Icons.badge,
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(7)],
              ),
              const SizedBox(height: 15),

              _buildSecaoTitulo("Localização do Problema"),
              const SizedBox(height: 16),

              // Endereço
              TextFormField(
                controller: _enderecoEstacionamentoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Endereço', Icons.location_on),
                validator: (val) => val!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              // Ponto de referência
              TextFormField(
                controller: _pontoReferenciaEstacionamentoController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Ponto de referência ou observações',
                  Icons.pin_drop,
                ),
              ),
              const SizedBox(height: 25),

              _buildSecaoTitulo("Detalhes Adicionais"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoEstacionamentoController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Descrição do problema',
                  Icons.description,
                  hint: "Ex: A placa de PARE está pichada e torta.",
                ),
              ),
              const SizedBox(height: 25),

              SeletorMidiaWidget(
                midias: _selectedMediaItemsEstacionamento,
                titulo: 'Prova Visual - Mídia (imagens ou vídeos)',
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItemsEstacionamento
                    ..clear()
                    ..addAll(novaLista),
                ),
              ),
              SeletorMidiaWidget(
                midias: _selectedMediaItemsEstacionamento,
                titulo: 'Prova Visual - Mídia (imagens ou vídeos)',
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItemsEstacionamento
                    ..clear()
                    ..addAll(novaLista),
                ),
              ),
              const SizedBox(height: 40),

              // Botão de Envio
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(
                      alpha: 0.8,
                    ), // Cor de alerta
                  ),
                  child: const Text(
                    'ENVIAR DENÚNCIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        color: AppCores.neonBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
