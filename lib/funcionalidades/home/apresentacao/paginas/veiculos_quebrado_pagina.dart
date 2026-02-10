import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/media_item.dart';
import '../../../../core/repositorios/reporte_repositorio_local.dart';
import '../../dados/modelos/reporte_veiculo.dart';

class TelaVeiculoQuebrado extends StatefulWidget {
  const TelaVeiculoQuebrado({super.key});

  @override
  State<TelaVeiculoQuebrado> createState() => _TelaVeiculoQuebradoState();
}

class _TelaVeiculoQuebradoState extends State<TelaVeiculoQuebrado> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _repositorio = ReporteRepositorioLocal();

  // Controllers e variáveis de estado
  String? _selecionaTipoVeiculo;
  final _placaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _corController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _pontoReferenciaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final List<String> _tiposVeiculo = [
    'Carro',
    'Moto',
    'Caminhão',
    'Ônibus',
    'Outro - Especificar na descrição',
  ];

  final List<MediaItem> _selectedMediaItems = <MediaItem>[];

  @override
  void dispose() {
    _placaController.dispose();
    _modeloController.dispose();
    _marcaController.dispose();
    _corController.dispose();
    _enderecoController.dispose();
    _pontoReferenciaController.dispose();
    _descricaoController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
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

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final reporte = ReporteVeiculo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endereco: _enderecoController.text,
        pontoReferencia: _pontoReferenciaController.text.isNotEmpty
            ? _pontoReferenciaController.text
            : null,
        descricao: _descricaoController.text,
        midias: List.from(_selectedMediaItems),
        tipoVeiculo: _selecionaTipoVeiculo!,
        placa: _placaController.text,
        marca: _marcaController.text.isNotEmpty ? _marcaController.text : null,
        modelo:
            _modeloController.text.isNotEmpty ? _modeloController.text : null,
        cor: _corController.text.isNotEmpty ? _corController.text : null,
        nomeContato:
            _nomeController.text.isNotEmpty ? _nomeController.text : null,
        telefone: _telefoneController.text.isNotEmpty
            ? _telefoneController.text
            : null,
        email:
            _emailController.text.isNotEmpty ? _emailController.text : null,
      );

      await _repositorio.salvarReporte(reporte);

      // Logs de depuração
      debugPrint('--- Relatório de Veículo salvo ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Placa: ${reporte.placa}');
      debugPrint('Tipo: ${reporte.tipoVeiculo}');

      if (mounted) {
        //Remove qualquer SnackBar que esteja aberta no momento
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        //Exibe a SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'O reporte do veículo foi enviado!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: AppCores.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }

      //Limpa o formulário
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _selecionaTipoVeiculo = null;
      _placaController.clear();
      _marcaController.clear();
      _modeloController.clear();
      _corController.clear();
      _enderecoController.clear();
      _pontoReferenciaController.clear();
      _descricaoController.clear();
      _nomeController.clear();
      _telefoneController.clear();
      _emailController.clear();
      _selectedMediaItems.clear();
    });
  }

  // Estilo padronizado dos inputs
  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppCores.neonBlue),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
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
      appBar: AppBar(title: const Text('Veículo Quebrado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecaoTitulo("Dados do Veículo"),
              const SizedBox(height: 15),

              //Placa e Tipo
              TextFormField(
                controller: _placaController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Placa', Icons.badge),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(7)],
                validator: (val) => val!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                dropdownColor: AppCores.lightGray,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Tipo', Icons.car_crash_outlined),
                items: _tiposVeiculo
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selecionaTipoVeiculo = val),
                validator: (val) => val == null ? 'Selecione' : null,
              ),
              const SizedBox(height: 15),

              //Marca e Modelo
              TextFormField(
                controller: _marcaController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Marca', Icons.factory),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _modeloController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Modelo', Icons.directions_car),
              ),
              const SizedBox(height: 15),

              // Cor e Endereço
              TextFormField(
                controller: _corController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Cor do Veículo', Icons.palette),
              ),
              const SizedBox(height: 15),

              _buildSecaoTitulo("Localização do veículo"),
              const SizedBox(height: 15),

              TextFormField(
                controller: _enderecoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Endereço onde o veículo está',
                  Icons.location_on,
                ),
                validator: (val) => val!.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _pontoReferenciaController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Ponto de referência ou observações',
                  Icons.pin_drop,
                ),
              ),
              const SizedBox(height: 25),

              // Descrição
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle(
                  'Descrição do problema',
                  Icons.description,
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

              if (_selectedMediaItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedMediaItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
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
              const SizedBox(height: 25),

              _buildSecaoTitulo("Seus Dados (Opcional)"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Seu Nome', Icons.person),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('Telefone', Icons.phone),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(7)],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle('E-mail', Icons.email),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                  ),
                  child: const Text(
                    'REPORTAR VEÍCULO',
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
