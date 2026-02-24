import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class DicasEconomiaPagina extends StatelessWidget {
  const DicasEconomiaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> dicas = [
      {
        'titulo': 'Iluminação LED',
        'descricao':
            'Troque lâmpadas incandescentes por LED. Elas economizam até 80% e duram mais.',
        'impacto': 'Alto Impacto',
        'icone': Icons.lightbulb_outline,
      },
      {
        'titulo': 'Ar-Condicionado',
        'descricao':
            'Mantenha os filtros limpos e a temperatura em 23°C. Evite abrir portas e janelas.',
        'impacto': 'Alto Impacto',
        'icone': Icons.ac_unit,
      },
      {
        'titulo': 'Aparelhos em Stand-by',
        'descricao':
            'Retire da tomada aparelhos que não estão em uso. O modo espera pode somar 12% da conta.',
        'impacto': 'Médio Impacto',
        'icone': Icons.power_settings_new,
      },
      {
        'titulo': 'Chuveiro Elétrico',
        'descricao':
            'Nos dias quentes, use a chave na posição "Verão". Reduz o consumo em até 30%.',
        'impacto': 'Alto Impacto',
        'icone': Icons.shower_outlined,
      },
      {
        'titulo': 'Luz Natural',
        'descricao':
            'Abra as cortinas durante o dia e aproveite a luz do sol para iluminar a casa.',
        'impacto': 'Médio Impacto',
        'icone': Icons.wb_sunny_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dicas de Economia'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppCores.neonBlue : AppCores.neonBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Cabeçalho de Pontuação de Eficiência
          SliverToBoxAdapter(child: _buildHeaderEficiencia(context)),

          // Lista de Dicas
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCardDica(context, dicas[index]),
                childCount: dicas.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderEficiencia(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
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
            'Sua Eficiência este mês',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 10,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(AppCores.neonBlue),
                ),
              ),
              const Column(
                children: [
                  Text(
                    '75%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'BOM',
                    style: TextStyle(
                      color: AppCores.accentGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Você economizou 15kWh a mais que no mês passado!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDica(BuildContext context, Map<String, dynamic> dica) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppCores.deepBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(dica['icone'], color: AppCores.neonBlue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dica['titulo'],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildBadgeImpacto(dica['impacto']),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dica['descricao'],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeImpacto(String label) {
    bool isAlto = label == 'Alto Impacto';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAlto
            ? Colors.orange.withValues(alpha: 0.1)
            : AppCores.accentGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isAlto ? Colors.orange : AppCores.accentGreen,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
