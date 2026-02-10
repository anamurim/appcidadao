import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/media_item.dart';
import '../../../../core/repositorios/reporte_repositorio_local.dart';
import '../../dados/modelos/reporte_iluminacao.dart';

class TelaReporteIluminacao extends StatefulWidget {
  const TelaReporteIluminacao({super.key});

  @override
  State<TelaReporteIluminacao> createState() => _TelaReporteIluminacaoState();
}

class _TelaReporteIluminacaoState extends State<TelaReporteIluminacao> {
  final _formKey = GlobalKey<FormState>();
  final _repositorio = ReporteRepositorioLocal();

  // Controllers e variáveis de estado
  String? _selecionaTipoProblemaIluminacao;
  final _enderecoIluminacaoController = TextEditingController();
  final _numeroPosteController =
      TextEditingController(); // Importante para manutenção
  final _pontoReferenciaIluminacaoController = TextEditingController();
  final _descricaoIluminacaoController = TextEditingController();

  final List<String> _categoriasIluminacao = [
    'Lâmpada Apagada à Noite',
    'Lâmpada Acesa de Dia',
    'Lâmpada Oscilando (Piscando)',
    'Poste Danificado/Caído',
    'Luminária Quebrada/Solta',
    'Outro - Especificar na descrição',
  ];

  final List<MediaItem> _selectedMediaItemsIluminacao = <MediaItem>[];

  @override
  void dispose() {
    _enderecoIluminacaoController.dispose();
    _numeroPosteController.dispose();
    _pontoReferenciaIluminacaoController.dispose();
    _descricaoIluminacaoController.dispose();
    super.dispose();
  }

  void _addMedia(MediaType type) {
    setState(() {
      _selectedMediaItemsIluminacao.add(
        MediaItem(
          url: type == MediaType.image
              ? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'
              : 'video_placeholder',
          type: type,
        ),
      );
    });
  }

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

      final reporte = ReporteIluminacao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoIluminacaoController.text,
        pontoReferencia: _pontoReferenciaIluminacaoController.text.isNotEmpty
            ? _pontoReferenciaIluminacaoController.text
            : null,
        descricao: _descricaoIluminacaoController.text,
        midias: List.from(_selectedMediaItemsIluminacao),
        tipoProblema: _selecionaTipoProblemaIluminacao!,
        numeroPoste: _numeroPosteController.text.isNotEmpty
            ? _numeroPosteController.text
            : null,
      );

      await _repositorio.salvarReporte(reporte);

      debugPrint('--- Solicitação de Reparo de Iluminação salva ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Problema: ${reporte.tipoProblema}');
      debugPrint('Poste Nº: ${reporte.numeroPoste ?? "Não informado"}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppCores.lightGray,
            title: const Text(
              'Solicitação Registrada',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Recebemos seu reporte. O prazo para manutenção é de até 72 horas úteis.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  'ENTENDIDO',
                  style: TextStyle(color: AppCores.accentGreen),
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
      _selecionaTipoProblemaIluminacao = null;
      _enderecoIluminacaoController.clear();
      _numeroPosteController.clear();
      _pontoReferenciaIluminacaoController.clear();
      _descricaoIluminacaoController.clear();
      _selectedMediaItemsIluminacao.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iluminação Pública')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCabecalho(),
              const SizedBox(height: 25),

              _buildSecaoTitulo("O que está acontecendo?"),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Selecione o problema',
                  Icons.lightbulb,
                ),
                items: _categoriasIluminacao
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selecionaTipoProblemaIluminacao = val),
                validator: (val) => val == null ? 'Selecione uma opção' : null,
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Localização do problema"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _enderecoIluminacaoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Endereço completo', Icons.location_on),
                validator: (val) => val!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _numeroPosteController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Nº do Poste',
                  Icons.numbers,
                  hint: 'Opcional',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _pontoReferenciaIluminacaoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Ponto de Ref.', Icons.pin_drop),
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Mais Detalhes"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoIluminacaoController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Observações adicionais',
                  Icons.chat_bubble_outline,
                ),
              ),
              const SizedBox(height: 40),

              _buildSecaoTitulo("Mídia (imagens ou vídeos)"),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addMedia(MediaType.image),
                      icon: const Icon(
                        Icons.camera_alt,
                        color: AppCores.neonBlue,
                      ),
                      label: const Text(
                        'Foto',
                        style: TextStyle(color: AppCores.neonBlue),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppCores.lightGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addMedia(MediaType.video),
                      icon: const Icon(
                        Icons.videocam,
                        color: AppCores.neonBlue,
                      ),
                      label: const Text(
                        'Vídeo',
                        style: TextStyle(color: AppCores.neonBlue),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppCores.lightGray,
                      ),
                    ),
                  ),
                ],
              ),

              if (_selectedMediaItemsIluminacao.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMediaItemsIluminacao.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppCores.neonBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _selectedMediaItemsIluminacao[i].type == MediaType.image
                            ? Icons.image
                            : Icons.play_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
                    'SOLICITAR REPARO',
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

  Widget _buildCabecalho() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.neonBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppCores.neonBlue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Dica: O número do poste geralmente está gravado em uma placa metálica na altura dos olhos.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
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
