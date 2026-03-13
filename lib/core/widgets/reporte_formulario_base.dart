import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../funcionalidades/reportes/dominio/entidades/media_item.dart';
import '../../funcionalidades/home/controladores/reporte_controller.dart';
import '../constantes/cores.dart';
import '../modelos/reporte_base.dart';
import '../utilitarios/localizacao_service.dart';
import 'seletor_midia_widget.dart';

/// Configuração de um campo dropdown de categorias.
class CategoriaConfig {
  final String label;
  final IconData icone;
  final List<String> opcoes;

  const CategoriaConfig({
    required this.label,
    required this.icone,
    required this.opcoes,
  });
}

/// Widget base reutilizável para formulários de reporte urbano.
///
/// Encapsula os campos comuns (endereço, ponto de referência, descrição,
/// seletor de mídia) e aceita campos extras específicos de cada tipo.
///
/// Exemplo de uso:
/// ```dart
/// ReporteFormularioBase(
///   titulo: 'Iluminação Pública',
///   icone: Icons.lightbulb,
///   dica: 'O número do poste está na placa metálica.',
///   categoria: CategoriaConfig(
///     label: 'Tipo de problema',
///     icone: Icons.lightbulb,
///     opcoes: ['Lâmpada Apagada', 'Poste Danificado'],
///   ),
///   camposExtras: (inputStyle) => [/* widgets extras */],
///   onSubmit: (endereco, referencia, descricao, midias, categoria, extras) {
///     // Criar o modelo específico e submeter
///   },
/// )
/// ```
class ReporteFormularioBase extends StatefulWidget {
  /// Título exibido na AppBar.
  final String titulo;

  /// Dica exibida no cabeçalho do formulário (opcional).
  final String? dica;

  /// Configuração das categorias/tipos de problema.
  final CategoriaConfig? categoria;

  /// Builder para campos extras específicos de cada tipo de reporte.
  ///
  /// Recebe a função [inputStyle] para manter consistência visual.
  final List<Widget> Function(
    InputDecoration Function(String label, IconData icon, {String? hint})
        inputStyle,
  )? camposExtras;

  /// Callback de submissão com todos os dados do formulário.
  ///
  /// Recebe:
  /// - [endereco]: endereço do problema
  /// - [pontoReferencia]: ponto de referência (pode ser vazio)
  /// - [descricao]: descrição detalhada
  /// - [midias]: lista de mídia anexada
  /// - [categoriaSelecionada]: valor da categoria/dropdown (se houver)
  /// - [controllers]: mapa de TextEditingControllers extras (nome → controller)
  final Future<ReporteBase?> Function(
    String endereco,
    String? pontoReferencia,
    String descricao,
    List<MediaItem> midias,
    String? categoriaSelecionada,
  ) onSubmit;

  /// Texto do botão de submit.
  final String textoBotao;

  /// Mensagem de confirmação após submissão.
  final String mensagemSucesso;

  const ReporteFormularioBase({
    super.key,
    required this.titulo,
    this.dica,
    this.categoria,
    this.camposExtras,
    required this.onSubmit,
    this.textoBotao = 'ENVIAR REPORTE',
    this.mensagemSucesso =
        'Recebemos seu reporte. O prazo para atendimento é de até 72 horas úteis.',
  });

  @override
  State<ReporteFormularioBase> createState() => _ReporteFormularioBaseState();
}

class _ReporteFormularioBaseState extends State<ReporteFormularioBase> {
  final _formKey = GlobalKey<FormState>();
  String? _categoriaSelecionada;
  bool _loadingEndereco = false;

  final _enderecoController = TextEditingController();
  final _pontoReferenciaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final List<MediaItem> _midias = <MediaItem>[];

  @override
  void dispose() {
    _enderecoController.dispose();
    _pontoReferenciaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      prefixIcon:
          Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.1),
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

      final reporte = await widget.onSubmit(
        _enderecoController.text,
        _pontoReferenciaController.text.isNotEmpty
            ? _pontoReferenciaController.text
            : null,
        _descricaoController.text,
        List.from(_midias),
        _categoriaSelecionada,
      );

      if (reporte != null) {
        await context.read<ReporteController>().submeterReporte(reporte);

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
                widget.mensagemSucesso,
                style: TextStyle(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
        }
        _clearForm();
      }
    }
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _categoriaSelecionada = null;
      _enderecoController.clear();
      _pontoReferenciaController.clear();
      _descricaoController.clear();
      _midias.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
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
              // ── Dica (se fornecida) ──
              if (widget.dica != null) ...[
                _buildCabecalho(widget.dica!),
                const SizedBox(height: 25),
              ],

              // ── Dropdown de categoria (se fornecido) ──
              if (widget.categoria != null) ...[
                _buildSecaoTitulo('O que está acontecendo?'),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: _inputStyle(
                    widget.categoria!.label,
                    widget.categoria!.icone,
                  ),
                  items: widget.categoria!.opcoes
                      .map(
                          (p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _categoriaSelecionada = val),
                  validator: (val) =>
                      val == null ? 'Selecione uma opção' : null,
                ),
                const SizedBox(height: 20),
              ],

              // ── Localização ──
              _buildSecaoTitulo('Localização do problema'),
              const SizedBox(height: 15),
              TextFormField(
                controller: _enderecoController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration:
                    _inputStyle('Endereço completo', Icons.location_on)
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
                              final endereco = await LocalizacaoService
                                  .obterEnderecoAtual();
                              _enderecoController.text = endereco;
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao obter localização: $e',
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(
                                    () => _loadingEndereco = false);
                              }
                            }
                          },
                        ),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              // ── Campos extras (específicos de cada tipo) ──
              if (widget.camposExtras != null)
                ...widget.camposExtras!(_inputStyle),

              TextFormField(
                controller: _pontoReferenciaController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration:
                    _inputStyle('Ponto de Referência', Icons.pin_drop),
              ),
              const SizedBox(height: 20),

              // ── Descrição ──
              _buildSecaoTitulo('Mais Detalhes'),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoController,
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

              // ── Seletor de mídia ──
              SeletorMidiaWidget(
                midias: _midias,
                onChanged: (novaLista) => setState(
                  () => _midias
                    ..clear()
                    ..addAll(novaLista),
                ),
              ),
              const SizedBox(height: 40),

              // ── Botão submit ──
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
                    widget.textoBotao,
                    style: const TextStyle(
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

  Widget _buildCabecalho(String dica) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.neonBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppCores.neonBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              dica,
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
