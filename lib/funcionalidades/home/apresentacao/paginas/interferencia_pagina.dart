import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_interferencia.dart';

class TelaReportarInterferencia extends StatefulWidget {
  const TelaReportarInterferencia({super.key});

  @override
  State<TelaReportarInterferencia> createState() =>
      _TelaReportarInterferenciaState();
}

class _TelaReportarInterferenciaState extends State<TelaReportarInterferencia> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoInterferencia;
  final TextEditingController _enderecoInterferenciaController =
      TextEditingController();
  final TextEditingController _pontoReferenciaInterferenciaController =
      TextEditingController();
  final TextEditingController _descricaoInterferenciaController =
      TextEditingController();
  final TextEditingController _nomeContatoInterferenciaController =
      TextEditingController();
  final TextEditingController _emailContatoPhoneInterferenciaController =
      TextEditingController();

  final List<String> _tipoInterferencia = [
    'Buraco na Via',
    'Lixo/Entulho Descartado',
    'Árvore Caída/Galhos',
    'Calçada Danificada',
    'Obstrução de Via',
    'Bueiro Aberto/Quebrado',
    'Outro',
  ];

  final List<MediaItem> _selectedMediaItemsInterferencia = <MediaItem>[];

  @override
  void dispose() {
    _enderecoInterferenciaController.dispose();
    _pontoReferenciaInterferenciaController.dispose();
    _descricaoInterferenciaController.dispose();
    _nomeContatoInterferenciaController.dispose();
    _emailContatoPhoneInterferenciaController.dispose();
    super.dispose();
  }



  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final reporte = ReporteInterferencia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoInterferenciaController.text,
        pontoReferencia: _pontoReferenciaInterferenciaController.text.isNotEmpty
            ? _pontoReferenciaInterferenciaController.text
            : null,
        descricao: _descricaoInterferenciaController.text,
        midias: List.from(_selectedMediaItemsInterferencia),
        tipoInterferencia: _selecionaTipoInterferencia!,
        nomeContato: _nomeContatoInterferenciaController.text.isNotEmpty
            ? _nomeContatoInterferenciaController.text
            : null,
        emailContato: _emailContatoPhoneInterferenciaController.text.isNotEmpty
            ? _emailContatoPhoneInterferenciaController.text
            : null,
      );

      await context.read<ReporteController>().submeterReporte(reporte);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Relato enviado com sucesso!'),
            backgroundColor: AppCores.accentGreen,
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
      _selecionaTipoInterferencia = null;
      _enderecoInterferenciaController.clear();
      _pontoReferenciaInterferenciaController.clear();
      _descricaoInterferenciaController.clear();
      _nomeContatoInterferenciaController.clear();
      _emailContatoPhoneInterferenciaController.clear();
      _selectedMediaItemsInterferencia.clear();
    });
  }

  // Helper para criar o estilo dos campos de texto consistente com o tema escuro
  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppCores.neonBlue), // Adiciona o ícone aqui
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppCores.neonBlue.withValues(alpha: 0.1)),
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
      backgroundColor: AppCores.techGray, // Cor de fundo do app
      appBar: AppBar(
        title: const Text('Interferência na Via'),
        backgroundColor: AppCores.deepBlue, // Cor da AppBar
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Relate as interferências encontradas na Via.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Campos com * são obrigatórios.',
                  style: TextStyle(
                    color: AppCores.accentGreen,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 15),

                _buildSecaoTitulo("Informações da interferência"),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  dropdownColor: AppCores.lightGray,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle(
                    'Tipo de Interferência *',
                    Icons.merge_type,
                  ),
                  initialValue: _selecionaTipoInterferencia,
                  items: _tipoInterferencia
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selecionaTipoInterferencia = val),
                  validator: (val) => val == null ? 'Selecione um tipo' : null,
                ),
                const SizedBox(height: 16),

                _buildSecaoTitulo("Localização do Problema"),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _enderecoInterferenciaController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle(
                    'Endereço *',
                    Icons.location_on,
                    hint: 'Ex: Rua das Flores',
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Informe o endereço' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _pontoReferenciaInterferenciaController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle(
                    'Ponto de referência ou observações',
                    Icons.pin_drop,
                  ),
                ),
                const SizedBox(height: 25),

                TextFormField(
                  controller: _descricaoInterferenciaController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle(
                    'Descrição do problema',
                    Icons.description,
                  ),
                  maxLines: 4,
                  validator: (val) =>
                      val!.isEmpty ? 'Descreva o problema' : null,
                ),
                const SizedBox(height: 25),

                SeletorMidiaWidget(
                  midias: _selectedMediaItemsInterferencia,
                  onChanged: (novaLista) => setState(
                    () => _selectedMediaItemsInterferencia
                      ..clear()
                      ..addAll(novaLista),
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppCores.electricBlue, // Destaque visual
                      foregroundColor: AppCores.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ENVIAR REPORTE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed: _clearForm,
                    child: const Text(
                      'Limpar Campos',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
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
