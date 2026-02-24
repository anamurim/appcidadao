import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';
import '../../../perfil/tela_perfil.dart';
import '../../../ajustes/apresentacao/paginas/seguranca_pagina.dart';
import '../../../ajustes/apresentacao/paginas/notificacoes_aplicativo_pagina.dart';
import '../../../ajustes/apresentacao/paginas/ajuste_tema_pagina.dart';
import '../../../ajustes/apresentacao/paginas/suporte_pagina.dart';

class AjustesPagina extends StatelessWidget {
  final VoidCallback onBackToHome;

  const AjustesPagina({super.key, required this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        //backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: onBackToHome,
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao(context, 'Minha Conta'),
            _buildCardItem(
              icon: Icons.person_outline,
              titulo: 'Perfil',
              subtitulo: 'Editar nome, e-mail e foto',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaPerfil()),
                );
              },
            ),
            _buildCardItem(
              icon: Icons.lock_outline,
              titulo: 'Segurança',
              subtitulo: 'Alterar senha e biometria',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaSeguranca(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSecao(context, 'Preferências'),
            _buildCardItem(
              icon: Icons.notifications_none_outlined,
              titulo: 'Notificações',
              subtitulo: 'Gerenciar alertas do app',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaNotificacoesAplicativo(),
                  ),
                );
              },
            ),
            _buildCardItem(
              icon: Icons.dark_mode_outlined,
              titulo: 'Tema',
              subtitulo: 'Claro, escuro ou sistema',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AjustesTema()),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSecao(context, 'Suporte'),
            _buildCardItem(
              icon: Icons.help_outline_rounded,
              titulo: 'Ajuda e Suporte',
              subtitulo: 'FAQ e contato',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaSuporte()),
                );
              },
            ),
            _buildCardItem(
              icon: Icons.info_outline,
              titulo: 'Sobre o App',
              subtitulo: 'Versão e informações',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'App Cidadão',
                  applicationVersion: '1.0.0',
                  applicationIcon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppCores.electricBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  children: const [
                    Text(
                      'App Cidadão é uma plataforma para reportar problemas '
                      'urbanos e contribuir para a melhoria da sua cidade. '
                      'Relate interferências na via, semáforos, veículos '
                      'quebrados e muito mais.',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () => FuncoesAuxiliares.exibirLogout(context),
                child: const Text(
                  'Sair da Conta',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecao(BuildContext context, String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required IconData icon,
    required String titulo,
    String? subtitulo,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppCores.neonBlue),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitulo != null ? Text(subtitulo) : null,
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
