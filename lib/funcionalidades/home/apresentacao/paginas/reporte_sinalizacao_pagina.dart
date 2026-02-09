import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import '../../../../core/constantes/cores.dart';

enum MediaType { image, video }

class MediaItem {
  final String url;
  final MediaType type;
  const MediaItem({required this.url, required this.type});
}

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

  void _addMedia(MediaType type) {
    setState(() {
      _selectedMediaItemsSinalizacao.add(
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
      hintText: hint, // Agora o parâmetro existe e pode ser usado aqui
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

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      debugPrint('--- Reporte de Sinalização ---');
      debugPrint('Tipo: $_selecionaTipoSinalizacao');
      debugPrint('Endereço: ${_enderecoSinalizacaoController.text}');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppCores.lightGray,
          title: const Text(
            'Reporte Enviado',
            style: TextStyle(color: Color.fromARGB(255, 2, 1, 1)),
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

              if (_selectedMediaItemsSinalizacao.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMediaItemsSinalizacao.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppCores.neonBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _selectedMediaItemsSinalizacao[i].type ==
                                MediaType.image
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

  /*Widget _buildBotaoFoto() {
    return InkWell(
      onTap: () {}, // Implementação futura da câmera
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppCores.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
        ),
        child: const Column(
          children: [
            Icon(Icons.add_a_photo, color: AppCores.neonBlue, size: 32),
            SizedBox(height: 8),
            Text(
              "Tirar foto da sinalização",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }*/
}
