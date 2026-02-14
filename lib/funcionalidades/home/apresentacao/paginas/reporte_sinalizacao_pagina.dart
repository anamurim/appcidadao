import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
<<<<<<< HEAD
import '../../../reportes/media_item.dart';
=======
import '../../../reportes/dominio/entidades/media_item.dart';
>>>>>>> fcb63e66a5b7cad3745b145988a00c8127db5855
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_sinalizacao.dart';

class TelaReporteSinalizacao extends StatefulWidget {
  const TelaReporteSinalizacao({super.key});

  @override
  State<TelaReporteSinalizacao> createState() => _TelaReporteSinalizacaoState();
}

class _TelaReporteSinalizacaoState extends State<TelaReporteSinalizacao> {
  final _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoSinalizacao;
  final _enderecoSinalizacaoController = TextEditingController();
  final _pontoReferenciaSinalizacaoController = TextEditingController();
  final _descricaoSinalizacaoController = TextEditingController();

  final List<String> _categoriasSinalizacao = [
    'Placa de Trânsito Danificada',
    'Placa de Identificação de Rua Faltando',
    'Semáforo com Lâmpada Queimada',
    'Faixa de Pedestres Apagada',
    'Pintura de Solo (Pare/Devagar) Inexistente',
    'Outro',
  ];

  final List<MediaItem> _selectedMediaItemsSinalizacao = <MediaItem>[];

  @override
  void dispose() {
    _enderecoSinalizacaoController.dispose();
    _pontoReferenciaSinalizacaoController.dispose();
    _descricaoSinalizacaoController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
=======


>>>>>>> fcb63e66a5b7cad3745b145988a00c8127db5855
  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30),
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

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final reporte = ReporteSinalizacao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoSinalizacaoController.text,
        pontoReferencia: _pontoReferenciaSinalizacaoController.text.isNotEmpty
            ? _pontoReferenciaSinalizacaoController.text
            : null,
        descricao: _descricaoSinalizacaoController.text,
        midias: List.from(_selectedMediaItemsSinalizacao),
        tipoSinalizacao: _selecionaTipoSinalizacao!,
      );

      await context.read<ReporteController>().submeterReporte(reporte);

      debugPrint('--- Reporte de Sinalização salvo ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Tipo: ${reporte.tipoSinalizacao}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppCores.lightGray,
            title: const Text(
              'Reporte Enviado',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Obrigado! Sua colaboração ajuda a tornar o trânsito mais seguro para todos.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  'FECHAR',
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
      _selecionaTipoSinalizacao = null;
      _enderecoSinalizacaoController.clear();
      _pontoReferenciaSinalizacaoController.clear();
      _descricaoSinalizacaoController.clear();
      _selectedMediaItemsSinalizacao.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Problema na Sinalização')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecaoTitulo("Informações do problema na sinalização"),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Categoria de Sinalização',
                  Icons.category,
                ),
                items: _categoriasSinalizacao
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selecionaTipoSinalizacao = val),
                validator: (val) =>
                    val == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Localização do Problema"),
              const SizedBox(height: 15),

              TextFormField(
                controller: _enderecoSinalizacaoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Endereço ou Cruzamento',
                  Icons.location_on,
                ),
                validator: (val) => val!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _pontoReferenciaSinalizacaoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Ponto de Referência', Icons.pin_drop),
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Detalhes Adicionais"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoSinalizacaoController,
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
                midias: _selectedMediaItemsSinalizacao,
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItemsSinalizacao
                    ..clear()
                    ..addAll(novaLista),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ENVIAR REPORTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
