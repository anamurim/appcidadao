import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class AjustesTema extends StatefulWidget {
  const AjustesTema({super.key});

  @override
  State<AjustesTema> createState() => _AjustesTemaState();
}

class _AjustesTemaState extends State<AjustesTema> {
  ThemeMode _temaSelecionado = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tema do Aplicativo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao('APARÊNCIA'),

            _buildTemaOption(
              titulo: 'Padrão do sistema',
              subtitulo:
                  'Ajusta a aparência com base nas configurações do seu dispositivo',
              valor: ThemeMode.system,
              icon: Icons.brightness_auto_outlined,
            ),

            _buildTemaOption(
              titulo: 'Modo Escuro',
              subtitulo: 'Ideal para ambientes com pouca luz',
              valor: ThemeMode.dark,
              icon: Icons.dark_mode_outlined,
            ),

            _buildTemaOption(
              titulo: 'Modo Claro',
              subtitulo: 'Aparência clássica com alto contraste',
              valor: ThemeMode.light,
              icon: Icons.light_mode_outlined,
            ),

            const SizedBox(height: 24),

            Card(
              color: AppCores.lightGray.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppCores.neonBlue,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'O modo escuro ajuda a economizar bateria em telas OLED e reduz o cansaço visual.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemaOption({
    required String titulo,
    required String subtitulo,
    required ThemeMode valor,
    required IconData icon,
  }) {
    bool isSelected = _temaSelecionado == valor;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? AppCores.neonBlue
              : Colors.grey.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      // ignore: deprecated_member_use
      child: RadioListTile<ThemeMode>(
        activeColor: AppCores.neonBlue,
        value: valor,
        // ignore: deprecated_member_use
        groupValue: _temaSelecionado,
        // ignore: deprecated_member_use
        onChanged: (ThemeMode? novoValor) {
          if (novoValor != null) {
            setState(() {
              _temaSelecionado = novoValor;
            });
          }
        },
        title: Row(
          children: [
            Icon(icon, color: AppCores.electricBlue, size: 22),
            const SizedBox(width: 12),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 12)),
        secondary: isSelected
            ? const Icon(Icons.check_circle, color: AppCores.neonBlue)
            : null,
      ),
    );
  }

  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
