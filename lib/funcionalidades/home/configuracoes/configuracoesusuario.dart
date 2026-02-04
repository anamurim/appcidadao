import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../core/utilitarios/funcoesauxiliares.dart';

class ConfiguracoesUsuario extends StatelessWidget {
  const ConfiguracoesUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50], // Fundo levemente cinza para destacar os cards
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao('Minha Conta'),
            _buildCardItem(
              icon: Icons.person_outline,
              titulo: 'Perfil',
              subtitulo: 'Editar nome, e-mail e foto',
              onTap: () {},
            ),
            _buildCardItem(
              icon: Icons.lock_outline,
              titulo: 'Segurança',
              subtitulo: 'Alterar senha e biometria',
              onTap: () {},
            ),

            const SizedBox(height: 24),
            _buildSecao('Preferências'),
            _buildCardItem(
              icon: Icons.notifications_none,
              titulo: 'Notificações',
              subtitulo: 'Gerenciar alertas do aplicativo',
              onTap: () {},
            ),
            _buildCardItem(
              icon: Icons.dark_mode_outlined,
              titulo: 'Aparência',
              subtitulo: 'Tema claro, escuro ou sistema',
              onTap: () {},
            ),

            const SizedBox(height: 24),
            _buildSecao('Suporte'),
            _buildCardItem(
              icon: Icons.help_outline,
              titulo: 'Ajuda e FAQ',
              onTap: () {},
            ),
            _buildCardItem(
              icon: Icons.info_outline,
              titulo: 'Sobre o App',
              onTap: () {},
            ),

            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () {
                FuncoesAuxiliares.exibirLogout(context);
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os títulos das seções
  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: TextStyle(
          color: AppCores.deepBlue.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget auxiliar para os itens da lista (Cards)
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
        leading: Icon(icon, color: AppCores.electricBlue),
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
