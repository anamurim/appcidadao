import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constantes/cores.dart';
import 'termos_uso_pagina.dart';
import 'politica_privacidade_pagina.dart';

class TelaSuporte extends StatelessWidget {
  const TelaSuporte({super.key});

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/5598999999999?text=Olá! Preciso de ajuda com o App Cidadão.',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o WhatsApp.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _abrirEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'suporte@appcidadao.com.br',
      queryParameters: {
        'subject': 'Suporte - App Cidadão',
        'body': 'Olá, preciso de ajuda com...',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o app de e-mail.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suporte e Ajuda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao('Canais de Atendimento'),

            _buildCardSuporte(
              icon: Icons.chat_outlined,
              titulo: 'Chat via WhatsApp',
              subtitulo: 'Atendimento rápido em horário comercial',
              onTap: () => _abrirWhatsApp(context),
            ),

            _buildCardSuporte(
              icon: Icons.email_outlined,
              titulo: 'Enviar E-mail',
              subtitulo: 'suporte@appcidadao.com.br',
              onTap: () => _abrirEmail(context),
            ),

            const SizedBox(height: 24),
            _buildSecao('Perguntas Frequentes'),

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
            _buildSecao('Documentos Legais'),
            _buildCardSuporte(
              icon: Icons.description_outlined,
              titulo: 'Termos de Uso',
              subtitulo: 'Regras e condições de uso do aplicativo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaTermosUso(),
                  ),
                );
              },
            ),

            _buildCardSuporte(
              icon: Icons.privacy_tip_outlined,
              titulo: 'Política de Privacidade',
              subtitulo: 'Como cuidamos dos seus dados pessoais',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaPoliticaPrivacidade(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                'App Cidadão v1.0.0',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os botões de contato
  Widget _buildCardSuporte({
    required IconData icon,
    required String titulo,
    required String subtitulo,
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  // Widget de FAQ em formato de ExpansionTile
  Widget _buildFAQItem({required String pergunta, required String resposta}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: AppCores.neonBlue,
        collapsedIconColor: AppCores.electricBlue,
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

  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
