import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../../core/utilitarios/localizacao_service.dart';
import '../../../../core/modelos/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_estacionamento.dart';
import '../../../../core/modelos/reporte_base.dart';

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
  final _tipoInfracaoController = TextEditingController();
  bool _loadingEndereco = false;
  final _placaController = TextEditingController();
  final _enderecoEstacionamentoController = TextEditingController();
  final _pontoReferenciaEstacionamentoController = TextEditingController();
  final _descricaoEstacionamentoController = TextEditingController();

  /*final List<String> _tipoInfracoes = [
    'Fila Dupla',
    'Vaga de Idoso/PNE sem cartão',
    'Guia Rebaixada (Entrada/Saída de veículos)',
    'Estacionar sobre a Calçada',
    'Ponto de Ônibus',
    'Estacionar em local proibido (Placa R6a/R6c)',
    'Outro - Especificar na descrição',
  ];*/

  final List<MediaItem> _selectedMediaItems = <MediaItem>[];

  @override
  void dispose() {
    _placaController.dispose();
    _tipoInfracaoController.dispose();
    _enderecoEstacionamentoController.dispose();
    _pontoReferenciaEstacionamentoController.dispose();
    _descricaoEstacionamentoController.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      filled: true,
      fillColor: AppCores.lightGray.withValues(alpha: 0.2),
    );
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final reporte = ReporteEstacionamento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoEstacionamentoController.text,
        pontoReferencia:
            _pontoReferenciaEstacionamentoController.text.isNotEmpty
            ? _pontoReferenciaEstacionamentoController.text
            : null,
        descricao: _descricaoEstacionamentoController.text,
        midias: List.from(_selectedMediaItems),
        tipoInfracao: _tipoInfracaoController.text,
        placaVeiculo: _placaController.text.isNotEmpty
            ? _placaController.text
            : null,
      );

      try {
        await context.read<ReporteController>().submeterReporte(
          reporte as ReporteBase,
        );

        debugPrint('--- Relatório de Estacionamento Irregular salvo ---');
        debugPrint('ID: ${reporte.id}');
        debugPrint('Infração: ${reporte.tipoInfracao}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Denúncia enviada com sucesso!'),
              backgroundColor: AppCores.accentGreen,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao enviar denúncia: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _tipoInfracaoController.clear();
      _placaController.clear();
      _enderecoEstacionamentoController.clear();
      _pontoReferenciaEstacionamentoController.clear();
      _descricaoEstacionamentoController.clear();
      _selectedMediaItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionamento Irregular'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecaoTitulo("Detalhes da Infração"),
              const SizedBox(height: 15),

              TextFormField(
                controller: _tipoInfracaoController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Tipo de Irregularidade *',
                  Icons.warning_amber_rounded,
                  hint: 'Ex: Fila dupla, vaga de idoso...',
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Informe o tipo de irregularidade'
                    : null,
              ),
              const SizedBox(height: 15),

              // Placa do Veículo
              TextFormField(
                controller: _placaController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle('Endereço', Icons.location_on).copyWith(
                  suffixIcon: _loadingEndereco
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () async {
                            setState(() => _loadingEndereco = true);
                            try {
                              final endereco =
                                  await LocalizacaoService.obterEnderecoAtual();
                              _enderecoEstacionamentoController.text = endereco;
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Erro ao obter localização: $e',
                                  ),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _loadingEndereco = false);
                              }
                            }
                          },
                        ),
                ),
                validator: (val) => val!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              // Ponto de referência
              TextFormField(
                controller: _pontoReferenciaEstacionamentoController,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Descrição do problema',
                  Icons.description,
                  hint: "Ex: A placa de PARE está pichada e torta.",
                ),
              ),
              const SizedBox(height: 25),

              SeletorMidiaWidget(
                midias: _selectedMediaItems,
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItems
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
                      alpha: 0.9,
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
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
