import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class ResumoContaWidget extends StatelessWidget {
  const ResumoContaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo da Conta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Última Fatura', 'R\$ 250,45', Icons.receipt),
          const SizedBox(height: 12),
          _buildInfoItem('Vencimento', '05/02/2026', Icons.calendar_today),
          const SizedBox(height: 12),
          _buildInfoItem(
            'Status',
            'Em dia',
            Icons.check_circle,
            color: AppCores.accentGreen,
          ),
          const SizedBox(height: 12),
          _buildInfoItem('Próxima Leitura', '15/02/2026', Icons.speed),
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
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
