import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class SuporteEnergiaPagina extends StatelessWidget {
  const SuporteEnergiaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Central de Suporte'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppCores.neonBlue : AppCores.neonBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildBarraBusca(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSecaoTitulo(context, 'Como podemos ajudar?'),
                const SizedBox(height: 15),
                _buildGridCategorias(context),
                const SizedBox(height: 30),
                _buildSecaoTitulo(context, 'Dúvidas Frequentes'),
                const SizedBox(height: 15),
                _buildFaqItem(context, 'Como solicitar religação?'),
                _buildFaqItem(context, 'Entenda os impostos na sua fatura'),
                _buildFaqItem(context, 'Como alterar o titular da conta?'),
                const SizedBox(height: 30),
                _buildCardContatoDireto(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraBusca(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: AppCores.deepBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Busque por problemas ou dúvidas...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          prefixIcon: const Icon(Icons.search, color: AppCores.neonBlue),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoTitulo(BuildContext context, String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGridCategorias(BuildContext context) {
    final categorias = [
      {'label': 'Fatura', 'icon': Icons.description_outlined},
      {'label': 'Falta de Luz', 'icon': Icons.power_off_outlined},
      {'label': 'Instalações', 'icon': Icons.construction_outlined},
      {'label': 'Denúncias', 'icon': Icons.report_problem_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.5,
      ),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categorias[index]['icon'] as IconData,
                color: AppCores.neonBlue,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                categorias[index]['label'] as String,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFaqItem(BuildContext context, String pergunta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          pergunta,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppCores.neonBlue),
        onTap: () {},
      ),
    );
  }

  Widget _buildCardContatoDireto(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppCores.deepBlue,
            AppCores.electricBlue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppCores.neonBlue,
            radius: 25,
            child: Icon(Icons.headset_mic, color: AppCores.deepBlue),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ainda precisa de ajuda?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fale com nossos atendentes agora.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppCores.neonBlue,
              foregroundColor: AppCores.deepBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'CHAT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
