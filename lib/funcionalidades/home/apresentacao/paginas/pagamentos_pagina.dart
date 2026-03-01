import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/utilitarios/fatura_service.dart';

class HistoricoPagamentosPagina extends StatelessWidget {
  const HistoricoPagamentosPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dados fictícios dos últimos 6 meses
    final List<Map<String, dynamic>> faturas = [
      {
        'mes': 'Fevereiro',
        'ano': '2026',
        'valor': 245.50,
        'status': 'Paga',
        'data': '10/02/2026',
      },
      {
        'mes': 'Janeiro',
        'ano': '2026',
        'valor': 210.20,
        'status': 'Paga',
        'data': '12/01/2026',
      },
      {
        'mes': 'Dezembro',
        'ano': '2025',
        'valor': 280.00,
        'status': 'Atraso',
        'data': 'Vencida',
      },
      {
        'mes': 'Novembro',
        'ano': '2025',
        'valor': 195.40,
        'status': 'Paga',
        'data': '10/11/2025',
      },
      {
        'mes': 'Outubro',
        'ano': '2025',
        'valor': 220.00,
        'status': 'Paga',
        'data': '13/10/2025',
      },
      {
        'mes': 'Setembro',
        'ano': '2025',
        'valor': 205.15,
        'status': 'Paga',
        'data': '11/09/2025',
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Histórico de Faturas'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppCores.neonBlue : Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildResumoGeral(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: faturas.length,
              itemBuilder: (context, index) {
                return _buildCardFatura(context, faturas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoGeral(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppCores.deepBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Total Pendente',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          const Text(
            'R\$ 280,00',
            style: TextStyle(
              color: AppCores.neonBlue,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '1 FATURA EM ATRASO',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFatura(BuildContext context, Map<String, dynamic> fatura) {
    final theme = Theme.of(context);
    final bool estaPaga = fatura['status'] == 'Paga';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: estaPaga
              ? Colors.transparent
              : Colors.redAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: estaPaga
                  ? AppCores.neonBlue.withValues(alpha: 0.1)
                  : Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              estaPaga ? Icons.check_circle_outline : Icons.error_outline,
              color: estaPaga ? AppCores.neonBlue : Colors.redAccent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fatura['mes']} / ${fatura['ano']}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  estaPaga
                      ? 'Pago em: ${fatura['data']}'
                      : 'Vencimento em atraso',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${fatura['valor'].toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppCores.neonBlue,
                ),
                onPressed: () {
                  FaturaService.gerarEBaixarFatura(
                    mes: fatura['mes'],
                    valor: fatura['valor'].toString(),
                    status: fatura['status'],
                  );
                },
              ),
              Text(
                fatura['status'].toUpperCase(),
                style: TextStyle(
                  color: estaPaga ? AppCores.accentGreen : Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
