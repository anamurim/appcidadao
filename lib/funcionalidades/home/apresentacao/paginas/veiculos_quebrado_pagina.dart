import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_veiculo.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/utilitarios/localizacao_service.dart';

class TelaVeiculoQuebrado extends StatefulWidget {
  const TelaVeiculoQuebrado({super.key});

  @override
  State<TelaVeiculoQuebrado> createState() => _TelaVeiculoQuebradoState();
}

class _TelaVeiculoQuebradoState extends State<TelaVeiculoQuebrado> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoVeiculo;
  bool _loadingEndereco = false;
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
        modelo: _modeloController.text.isNotEmpty
            ? _modeloController.text
            : null,
        cor: _corController.text.isNotEmpty ? _corController.text : null,
        nomeContato: _nomeController.text.isNotEmpty
            ? _nomeController.text
            : null,
        telefone: _telefoneController.text.isNotEmpty
            ? _telefoneController.text
            : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
      );

      await context.read<ReporteController>().submeterReporte(
        reporte as ReporteBase,
      );
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
        // Volta para a Home automaticamente
        Navigator.pop(context);
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
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppCores.neonBlue),
      ),
      filled: true,
      fillColor: AppCores.lightGray.withValues(alpha: 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículo Quebrado'),
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
              _buildSecaoTitulo("Dados do Veículo"),
              const SizedBox(height: 15),

              //Placa e Tipo
              TextFormField(
                controller: _placaController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Placa', Icons.badge),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(7)],
                validator: (val) => val!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                dropdownColor: theme.scaffoldBackgroundColor,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Marca', Icons.factory),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _modeloController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Modelo', Icons.directions_car),
              ),
              const SizedBox(height: 15),

              // Cor e Endereço
              TextFormField(
                controller: _corController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Cor do Veículo', Icons.palette),
              ),
              const SizedBox(height: 15),

              _buildSecaoTitulo("Localização do veículo"),
              const SizedBox(height: 15),

              TextFormField(
                controller: _enderecoController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration:
                    _inputStyle(
                      'Endereço onde o veículo está',
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
                                color: theme.colorScheme.onSurface,
                              ),
                              onPressed: () async {
                                setState(() => _loadingEndereco = true);
                                try {
                                  final endereco =
                                      await LocalizacaoService.obterEnderecoAtual();
                                  _enderecoController.text = endereco;
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
              const SizedBox(height: 15),

              TextFormField(
                controller: _pontoReferenciaController,
                maxLines: 2,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle(
                  'Descrição do problema',
                  Icons.description,
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
              const SizedBox(height: 25),

              _buildSecaoTitulo("Seus Dados (Opcional)"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Seu Nome', Icons.person),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Telefone', Icons.phone),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(7)],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
    final theme = Theme.of(context);
    return Text(
      titulo,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
