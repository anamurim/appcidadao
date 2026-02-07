import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

enum MediaType { image, video }

class MediaItem {
  final String url;
  final MediaType type;
  const MediaItem({required this.url, required this.type});
}

class TelaReportarInterferencia extends StatefulWidget {
  const TelaReportarInterferencia({super.key});

  @override
  State<TelaReportarInterferencia> createState() =>
      _TelaReportarInterferenciaState();
}

class _TelaReportarInterferenciaState extends State<TelaReportarInterferencia> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedInterferenceType;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _referencePointController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactEmailPhoneController =
      TextEditingController();

  final List<String> _interferenceTypes = [
    'Buraco na Via',
    'Lixo/Entulho Descartado',
    'Árvore Caída/Galhos',
    'Iluminação Pública Falha',
    'Calçada Danificada',
    'Sinalização Danificada',
    'Obstrução de Via',
    'Bueiro Aberto/Quebrado',
    'Outro',
  ];

  final List<MediaItem> _selectedMediaItems = <MediaItem>[];

  @override
  void dispose() {
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _referencePointController.dispose();
    _descriptionController.dispose();
    _contactNameController.dispose();
    _contactEmailPhoneController.dispose();
    super.dispose();
  }

  void _addMedia(MediaType type) {
    setState(() {
      _selectedMediaItems.add(
        MediaItem(
          url: type == MediaType.image
              ? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'
              : 'video_placeholder',
          type: type,
        ),
      );
    });
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enviando relato...'),
          backgroundColor: AppCores.accentGreen,
        ),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _selectedInterferenceType = null;
      _streetController.clear();
      _numberController.clear();
      _neighborhoodController.clear();
      _referencePointController.clear();
      _descriptionController.clear();
      _contactNameController.clear();
      _contactEmailPhoneController.clear();
      _selectedMediaItems.clear();
    });
  }

  // Helper para criar o estilo dos campos de texto consistente com o tema escuro
  InputDecoration _inputStyle(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppCores.neonBlue.withValues(alpha: 0.5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppCores.neonBlue, width: 2),
      ),
      filled: true,
      fillColor: AppCores.lightGray.withValues(alpha: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray, // Cor de fundo do app
      appBar: AppBar(
        title: const Text('REPORTAR INTERFERÊNCIA'),
        backgroundColor: AppCores.deepBlue, // Cor da AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Campos com * são obrigatórios.',
                style: TextStyle(
                  color: AppCores.neonBlue,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Tipo de Interferência *'),
                initialValue: _selectedInterferenceType, // CORRIGIDO AQUI
                items: _interferenceTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedInterferenceType = val),
                validator: (val) => val == null ? 'Selecione um tipo' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _streetController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Rua / Avenida *',
                  hint: 'Ex: Rua das Flores',
                ),
                validator: (val) => val!.isEmpty ? 'Informe a rua' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputStyle('Nº'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _neighborhoodController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputStyle('Bairro'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Descrição Detalhada *'),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? 'Descreva o problema' : null,
              ),
              const SizedBox(height: 25),

              const Text(
                'Mídia (imagens ou vídeos)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addMedia(MediaType.image),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppCores.lightGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addMedia(MediaType.video),
                      icon: const Icon(Icons.videocam),
                      label: const Text('Vídeo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppCores.lightGray,
                      ),
                    ),
                  ),
                ],
              ),

              if (_selectedMediaItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMediaItems.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => Container(
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppCores.neonBlue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _selectedMediaItems[i].type == MediaType.image
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
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.accentGreen, // Destaque visual
                    foregroundColor: AppCores.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ENVIAR REPORTE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }
}
