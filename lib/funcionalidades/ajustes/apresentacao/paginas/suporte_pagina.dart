import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class TelaSuporte extends StatelessWidget {
  const TelaSuporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajuda e Suporte',
          style: TextStyle(color: Colors.white),
        ),
        //backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: AppCores.neonBlue),
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao(context, 'Canais de Atendimento'),

            _buildCardSuporte(
              context: context,
              icon: Icons.chat_outlined,
              titulo: 'Chat via WhatsApp',
              subtitulo: 'Atendimento rápido em horário comercial',
              onTap: () {
                // Lógica para abrir link do WhatsApp
              },
            ),

            _buildCardSuporte(
              context: context,
              icon: Icons.email_outlined,
              titulo: 'Enviar E-mail',
              subtitulo: 'suporte@appcidadao.com.br',
              onTap: () {
                // Lógica para abrir app de e-mail
              },
            ),

            const SizedBox(height: 24),
            _buildSecao(context, 'Perguntas Frequentes'),

            _buildFAQItem(
              pergunta: 'Como alterar meus dados?',
              resposta:
                  'Você pode alterar seus dados acessando a aba Perfil nas configurações.',
            ),
            _buildFAQItem(
              pergunta: 'O aplicativo é seguro?',
              resposta:
                  'Sim, utilizamos criptografia de ponta a ponta e autenticação biométrica para proteger seus dados.',
            ),
            _buildFAQItem(
              pergunta: 'Como recuperar minha senha?',
              resposta:
                  'Na tela de login, clique em "Esqueci minha senha" para receber um link de redefinição.',
            ),

            const SizedBox(height: 24),
            _buildSecao(context, 'Documentos Legais'),
            _buildCardSuporte(
              context: context,
              icon: Icons.description_outlined,
              titulo: 'Termos de Uso',
              subtitulo: 'Regras e condições de uso do aplicativo',
              onTap: () {
                // Navigator.push para a tela de texto dos termos
              },
            ),

            _buildCardSuporte(
              context: context,
              icon: Icons.privacy_tip_outlined,
              titulo: 'Política de Privacidade',
              subtitulo: 'Como cuidamos dos seus dados pessoais',
              onTap: () {
                // Navigator.push para a tela de privacidade
              },
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                'App Cidadão v1.0.0',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os botões de contato (Baseado no seu padrão de cards)
  Widget _buildCardSuporte({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppCores.neonBlue),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 12)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onTap: onTap,
      ),
    );
  }

  // Widget de FAQ em formato de ExpansionTile (abre e fecha)
  Widget _buildFAQItem({required String pergunta, required String resposta}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: AppCores.neonBlue,
        collapsedIconColor: AppCores.neonBlue,
        title: Text(
          pergunta,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              resposta,
              style: const TextStyle(color: Colors.black87, height: 1.4),
            ),
          ),
        ],
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
}
