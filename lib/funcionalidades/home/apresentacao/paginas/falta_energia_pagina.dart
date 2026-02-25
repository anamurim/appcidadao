import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/seletor_midia_widget.dart';
import '../../../reportes/dominio/entidades/media_item.dart';

class FaltaEnergiaPagina extends StatefulWidget {
  const FaltaEnergiaPagina({super.key});

  @override
  State<FaltaEnergiaPagina> createState() => _FaltaEnergiaPaginaState();
}

enum TipoFalta { residencia, poste, rua }

class _FaltaEnergiaPaginaState extends State<FaltaEnergiaPagina> {
  final _formKey = GlobalKey<FormState>();
  TipoFalta _tipoSelecionado = TipoFalta.residencia;

  final _enderecoController = TextEditingController();
  final _numeroPosteController = TextEditingController();
  final _descricaoController = TextEditingController();
  final List<MediaItem> _selectedMedia = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Falta de Energia'),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppCores.neonBlue : AppCores.neonBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecaoTitulo(context, 'Onde falta energia?'),
              const SizedBox(height: 15),

              // Seletor de Tipo de Falta
              Center(
                child: SegmentedButton<TipoFalta>(
                  segments: const [
                    ButtonSegment(
                      value: TipoFalta.residencia,
                      label: Text('Casa'),
                      icon: Icon(Icons.home),
                    ),
                    ButtonSegment(
                      value: TipoFalta.poste,
                      label: Text('Poste'),
                      icon: Icon(Icons.highlight),
                    ),
                    ButtonSegment(
                      value: TipoFalta.rua,
                      label: Text('Rua'),
                      icon: Icon(Icons.map),
                    ),
                  ],
                  selected: {_tipoSelecionado},
                  onSelectionChanged: (Set<TipoFalta> novaSelecao) {
                    setState(() => _tipoSelecionado = novaSelecao.first);
                  },
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppCores.neonBlue,
                    selectedForegroundColor: AppCores.deepBlue,
                    side: BorderSide(
                      color: AppCores.neonBlue.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildSecaoTitulo(context, 'Dados da Localização'),
              const SizedBox(height: 15),

              TextFormField(
                controller: _enderecoController,
                decoration: _inputStyle(
                  context,
                  'Endereço Completo',
                  Icons.location_on,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 15),

              if (_tipoSelecionado == TipoFalta.poste) ...[
                TextFormField(
                  controller: _numeroPosteController,
                  decoration: _inputStyle(
                    context,
                    'Número do Poste (Opcional)',
                    Icons.numbers,
                  ),
                ),
                const SizedBox(height: 15),
              ],

              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: _inputStyle(
                  context,
                  'Detalhes (Ex: faíscas, fios caídos...)',
                  Icons.edit_note,
                ),
              ),
              const SizedBox(height: 25),

              _buildSecaoTitulo(context, 'Evidências Visuais'),
              const SizedBox(height: 15),

              SeletorMidiaWidget(
                midias: _selectedMedia,
                onChanged: (novaLista) => setState(() {
                  _selectedMedia.clear();
                  _selectedMedia.addAll(novaLista);
                }),
              ),

              const SizedBox(height: 40),

              // Botão de Envio
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _enviarProtocolo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'REGISTRAR OCORRÊNCIA',
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

  InputDecoration _inputStyle(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppCores.neonBlue),
      filled: true,
      fillColor: theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppCores.neonBlue),
      ),
    );
  }

  Widget _buildSecaoTitulo(BuildContext context, String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _enviarProtocolo() {
    if (_formKey.currentState!.validate()) {
      // Aqui entraria a lógica de integração com o controller
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Protocolo registrado com sucesso!'),
          backgroundColor: AppCores.accentGreen,
        ),
      );
      Navigator.pop(context);
    }
  }
}
