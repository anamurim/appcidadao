import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_sinalizacao.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/utilitarios/localizacao_service.dart';

class TelaReporteSinalizacao extends StatefulWidget {
  const TelaReporteSinalizacao({super.key});

  @override
  State<TelaReporteSinalizacao> createState() => _TelaReporteSinalizacaoState();
}

class _TelaReporteSinalizacaoState extends State<TelaReporteSinalizacao> {
  final _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoSinalizacao;
  bool _loadingEndereco = false;
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

  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    final theme = Theme.of(context); // Captura o tema atual
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface),
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      prefixIcon: Icon(icon, color: theme.colorScheme.onSurface),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
      filled: true,
      fillColor: AppCores.lightGray.withValues(alpha: 0.2),
    );
  }

  Future<void> _submitReport() async {
    final theme = Theme.of(context); // Captura o tema atual

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

      await context.read<ReporteController>().submeterReporte(
        reporte as ReporteBase,
      );
      debugPrint('--- Reporte de Sinalização salvo ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Tipo: ${reporte.tipoSinalizacao}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Reporte Enviado',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              'Obrigado! Sua colaboração ajuda a tornar o trânsito mais seguro para todos.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text(
                  'FECHAR',
                  style: TextStyle(color: theme.colorScheme.onSurface),
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
    final theme = Theme.of(context); // Captura o tema atual

    return Scaffold(
      appBar: AppBar(
        title: const Text('Problema na Sinalização'),
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
              _buildSecaoTitulo("Informações do problema na sinalização"),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                dropdownColor: theme.scaffoldBackgroundColor,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration:
                    _inputStyle(
                      'Endereço ou Cruzamento',
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
                                  _enderecoSinalizacaoController.text =
                                      endereco;
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
                controller: _pontoReferenciaSinalizacaoController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _inputStyle('Ponto de Referência', Icons.pin_drop),
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Detalhes Adicionais"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoSinalizacaoController,
                maxLines: 4,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
                  child: Text(
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
