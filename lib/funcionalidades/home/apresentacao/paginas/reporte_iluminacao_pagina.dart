import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_iluminacao.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/utilitarios/localizacao_service.dart';

class TelaReporteIluminacao extends StatefulWidget {
  const TelaReporteIluminacao({super.key});

  @override
  State<TelaReporteIluminacao> createState() => _TelaReporteIluminacaoState();
}

class _TelaReporteIluminacaoState extends State<TelaReporteIluminacao> {
  final _formKey = GlobalKey<FormState>();

  // Controllers e variáveis de estado
  String? _selecionaTipoProblemaIluminacao;
  bool _loadingEndereco = false;
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

  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      filled: true,
      fillColor: AppCores.lightGray.withValues(alpha: 0.2),
    );
  }

  Future<void> _submitReport() async {
    final theme = Theme.of(context);

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

      await context.read<ReporteController>().submeterReporte(
        reporte as ReporteBase,
      );

      debugPrint('--- Solicitação de Reparo de Iluminação salva ---');
      debugPrint('ID: ${reporte.id}');
      debugPrint('Problema: ${reporte.tipoProblema}');
      debugPrint('Poste Nº: ${reporte.numeroPoste ?? "Não informado"}');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Solicitação Registrada',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              'Recebemos seu reporte. O prazo para manutenção é de até 72 horas úteis.',
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
      appBar: AppBar(
        title: const Text('Iluminação Pública'),
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
              _buildCabecalho(),
              const SizedBox(height: 25),

              _buildSecaoTitulo("O que está acontecendo?"),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle('Endereço completo', Icons.location_on)
                    .copyWith(
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () async {
                                setState(() => _loadingEndereco = true);
                                try {
                                  final endereco =
                                      await LocalizacaoService.obterEnderecoAtual();
                                  _enderecoIluminacaoController.text = endereco;
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
                validator: (val) => val!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _numeroPosteController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Nº do Poste',
                  Icons.numbers,
                  hint: 'Opcional',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _pontoReferenciaIluminacaoController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle('Ponto de Ref.', Icons.pin_drop),
              ),
              const SizedBox(height: 20),

              _buildSecaoTitulo("Mais Detalhes"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoIluminacaoController,
                maxLines: 3,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: _inputStyle(
                  'Observações adicionais',
                  Icons.chat_bubble_outline,
                ),
              ),
              const SizedBox(height: 40),

              SeletorMidiaWidget(
                midias: _selectedMediaItemsIluminacao,
                onChanged: (novaLista) => setState(
                  () => _selectedMediaItemsIluminacao
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
        color: AppCores.neonBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Dica: O número do poste geralmente está gravado em uma placa metálica na altura dos olhos.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
