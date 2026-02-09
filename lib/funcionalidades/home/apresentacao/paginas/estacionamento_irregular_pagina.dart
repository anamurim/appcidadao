import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constantes/cores.dart';

enum MediaType { image, video }

class MediaItem {
  final String url;
  final MediaType type;
  const MediaItem({required this.url, required this.type});
}

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
    _descricaoEstacionamentoController.dispose();
    super.dispose();
  }

  void _addMedia(MediaType type) {
    setState(() {
      _selectedMediaItemsEstacionamento.add(
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

      debugPrint('--- Relatório de Estacionamento Irregular ---');
      debugPrint('Infração: $_selecionaTipoInfracao');
      debugPrint('Placa: ${_placaController.text}');
      debugPrint('Local: ${_enderecoEstacionamentoController.text}');

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
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _selecionaTipoInfracao = null;
      _placaController.clear();
      _enderecoEstacionamentoController.clear();
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

              // Descrição/Observações
              TextFormField(
                controller: _descricaoEstacionamentoController,
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

              _buildSecaoTitulo("Prova Visual - Mídia (imagens ou vídeos)"),
              const SizedBox(height: 10),

              /*_buildSecaoTitulo("Mídia (imagens ou vídeos)"),
              const SizedBox(height: 10),*/
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

              if (_selectedMediaItemsEstacionamento.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMediaItemsEstacionamento.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppCores.neonBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _selectedMediaItemsEstacionamento[i].type ==
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

  /*Widget _buildCardMidia() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.add_a_photo_outlined,
            color: AppCores.neonBlue,
            size: 40,
          ),
          const SizedBox(height: 10),
          const Text(
            "Anexe uma foto que comprove a irregularidade",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Tirar Foto",
              style: TextStyle(color: AppCores.neonBlue),
            ),
          ),
        ],
      ),
    );
  }*/
}
