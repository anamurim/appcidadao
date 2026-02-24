import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_semaforo.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/utilitarios/localizacao_service.dart';

class TelaReportarSemaforo extends StatefulWidget {
  const TelaReportarSemaforo({super.key});

  @override
  State<TelaReportarSemaforo> createState() => _TelaReportarSemaforoState();
}

class _TelaReportarSemaforoState extends State<TelaReportarSemaforo> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis de estado
  String? _selecionaTipoProblemaSemaforo;
  bool _loadingEndereco = false;
  final TextEditingController _enderecoSemaforoController =
      TextEditingController();
  final TextEditingController _pontoReferenciaSemaforoController =
      TextEditingController();
  final TextEditingController _descricaoSemaforoController =
      TextEditingController();

  final List<String> _problemTypes = [
    'Apagado',
    'Piscando',
    'Luzes Queimadas',
    'Sincronia Incorreta',
    'Poste Danificado',
    'Outro',
  ];

  final List<MediaItem> _selectedMediaItems = <MediaItem>[];

  @override
  void dispose() {
    _enderecoSemaforoController.dispose();
    _pontoReferenciaSemaforoController.dispose();
    _descricaoSemaforoController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final theme = Theme.of(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final reporte = ReporteSemaforo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoSemaforoController.text,
        pontoReferencia: _pontoReferenciaSemaforoController.text.isNotEmpty
            ? _pontoReferenciaSemaforoController.text
            : null,
        descricao: _descricaoSemaforoController.text,
        midias: List.from(_selectedMediaItems),
        tipoProblema: _selecionaTipoProblemaSemaforo!,
      );

      await context.read<ReporteController>().submeterReporte(
        reporte as ReporteBase,
      );

      debugPrint('Log de Desenvolvimento - Reporte salvo: ${reporte.toMap()}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Sucesso',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              'Seu relatório de semáforo foi enviado com sucesso.',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
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
      _selecionaTipoProblemaSemaforo = null;
      _enderecoSemaforoController.clear();
      _pontoReferenciaSemaforoController.clear();
      _descricaoSemaforoController.clear();
      _selectedMediaItems.clear();
    });
  }

  // Estilo padrão dos inputs para combinar com o app
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema no Semáforo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
              Text(
                "Descreva abaixo o problema no semáforo",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Localização
              _buildSecaoTitulo("Localização do semáforo"),
              const SizedBox(height: 15),

              TextFormField(
                controller: _enderecoSemaforoController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration:
                    _inputStyle(
                      'Localização (Rua/Cruzamento)',
                      Icons.location_on,
                    ).copyWith(
                      suffixIcon: _loadingEndereco
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                                  _enderecoSemaforoController.text = endereco;
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao obter localização: $e',
                                      ),
                                    ),
                                  );
                                } finally {
                                  if (mounted)
                                    setState(() => _loadingEndereco = false);
                                }
                              },
                            ),
                    ),
                validator: (val) => val!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 16),

              // Tipo de Problema (Dropdown)
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle('Tipo de Problema', Icons.traffic),
                initialValue: _selecionaTipoProblemaSemaforo,
                items: _problemTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selecionaTipoProblemaSemaforo = val),
                validator: (val) => val == null ? 'Selecione uma opção' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pontoReferenciaSemaforoController,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Ponto de referência ou observações',
                  Icons.pin_drop,
                ),
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descricaoSemaforoController,
                maxLines: 4,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Descrição  do problema',
                  Icons.description,
                ),
                validator: (val) => val!.isEmpty ? 'Descreva o problema' : null,
              ),
              const SizedBox(height: 30),

              SeletorMidiaWidget(
                midias: _selectedMediaItems,
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItems
                    ..clear()
                    ..addAll(novaLista),
                ),
              ),
              const SizedBox(height: 15),

              // Botão de Envio
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _submitReport,
                  label: const Text(
                    'ENVIAR RELATÓRIO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  icon: const Icon(Icons.send, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
