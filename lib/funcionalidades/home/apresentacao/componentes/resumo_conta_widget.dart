import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class ResumoContaWidget extends StatelessWidget {
  const ResumoContaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo da Conta',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            context,
            'Vencimento',
            '05/02/2026',
            Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'Vencimento',
            '05/02/2026',
            Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'Status',
            'Em dia',
            Icons.check_circle,
            color: AppCores.accentGreen,
          ),
          const SizedBox(height: 12),
          _buildInfoItem(context, 'Próxima Leitura', '15/02/2026', Icons.speed),
          const SizedBox(height: 20),

          // Botão de Pagamento com Gradiente
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppCores.electricBlue, AppCores.neonBlue],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  // Ação de pagar fatura
                },
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'PAGAR FATURA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os itens de informação
  Widget _buildInfoItem(
    BuildContext context, // Adicionado contexto para acessar o tema
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: color ?? colorScheme.onSurfaceVariant, // Cor suave para ícones
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant, // Texto secundário adaptável
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color ?? colorScheme.onSurface, // Texto principal adaptável
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
