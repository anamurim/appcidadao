import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class CardServico extends StatelessWidget {
  final Map<String, dynamic> dados;

  const CardServico({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final Color cor = dados['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: AppCores.lightGray.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () =>
            _showFeatureDetails(context), // _showFeatureDetails integrado
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(dados['icon'] as IconData, color: cor, size: 35),
            const SizedBox(height: 10),
            Text(
              dados['title'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _showFeatureDetails - Exibe detalhes do serviço clicado
  void _showFeatureDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppCores.techGray,
        title: Row(
          children: [
            Icon(dados['icon'], color: dados['color']),
            const SizedBox(width: 10),
            Text(dados['title'], style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Acessando o serviço de ${dados['title']}... Esta funcionalidade será implementada em breve.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'FECHAR',
              style: TextStyle(color: AppCores.neonBlue),
            ),
          ),
        ],
      ),
    );
  }
}
