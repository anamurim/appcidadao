import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_semaforo.dart';

class TelaReportarSemaforo extends StatefulWidget {
  const TelaReportarSemaforo({super.key});

  @override
  State<TelaReportarSemaforo> createState() => _TelaReportarSemaforoState();
}

class _TelaReportarSemaforoState extends State<TelaReportarSemaforo> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis de estado
  String? _selecionaTipoProblemaSemaforo;
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

      await context.read<ReporteController>().submeterReporte(reporte);

      debugPrint('Log de Desenvolvimento - Reporte salvo: ${reporte.toMap()}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppCores.lightGray,
            title: const Text('Sucesso', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Seu relatório de semáforo foi enviado com sucesso.',
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
                  style: TextStyle(
                    color: AppCores.neonBlue,
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
      labelStyle: const TextStyle(color: Colors.white70),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Problema no Semáforo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Descreva abaixo o problema no semáforo",
                style: TextStyle(
                  color: Colors.white,
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
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Localização (Rua/Cruzamento)',
                  Icons.location_on,
                ),
                validator: (val) => val!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 16),

              // Tipo de Problema (Dropdown)
              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
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
                style: const TextStyle(color: Colors.white),
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
                style: const TextStyle(color: Colors.white),
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
      style: const TextStyle(
        color: AppCores.neonBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
