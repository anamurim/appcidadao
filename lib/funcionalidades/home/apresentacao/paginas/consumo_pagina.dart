import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class ConsumoEnergiaPagina extends StatelessWidget {
  const ConsumoEnergiaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dados fictícios para os últimos 12 meses (Consumo em kWh)
    final List<Map<String, dynamic>> dadosConsumo = [
      {'mes': 'Jan', 'valor': 180.0},
      {'mes': 'Fev', 'valor': 210.0},
      {'mes': 'Mar', 'valor': 195.0},
      {'mes': 'Abr', 'valor': 170.0},
      {'mes': 'Mai', 'valor': 160.0},
      {'mes': 'Jun', 'valor': 155.0},
      {'mes': 'Jul', 'valor': 150.0},
      {'mes': 'Ago', 'valor': 165.0},
      {'mes': 'Set', 'valor': 190.0},
      {'mes': 'Out', 'valor': 220.0},
      {'mes': 'Nov', 'valor': 205.0},
      {'mes': 'Dez', 'valor': 230.0},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Consumo de Energia'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardInformativo(
              context,
              'Consumo Médio',
              '185.8 kWh',
              Icons.bolt,
            ),
            const SizedBox(height: 25),

            Text(
              'Histórico dos últimos 12 meses',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Área do Gráfico
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppCores.neonBlue.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: dadosConsumo.map((dado) {
                  return _buildBarraGrafico(
                    context,
                    dado['mes'],
                    dado['valor'],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),
            _buildListaConsumo(context, dadosConsumo),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraGrafico(BuildContext context, String mes, double valor) {
    final double alturaMaxima = 150; // altura relativa
    final double alturaBarra =
        (valor / 250) * alturaMaxima; // Proporção baseada em max 250kWh

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: alturaBarra,
          decoration: BoxDecoration(
            color: AppCores.neonBlue,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: AppCores.neonBlue.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mes,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildCardInformativo(
    BuildContext context,
    String titulo,
    String valor,
    IconData icone,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppCores.deepBlue, AppCores.electricBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icone, color: AppCores.neonBlue, size: 40),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaConsumo(
    BuildContext context,
    List<Map<String, dynamic>> dados,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: dados.reversed.map((dado) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${dado['mes']} 2025",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${dado['valor']} kWh",
                style: const TextStyle(
                  color: AppCores.neonBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
