import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class TelaPoliticaPrivacidade extends StatelessWidget {
  const TelaPoliticaPrivacidade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Política de Privacidade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Política de Privacidade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Última atualização: 23 de Fevereiro de 2026',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _buildSecao(
                '1. Coleta de Dados',
                'Coletamos informações pessoais fornecidas no cadastro (nome, e-mail, '
                    'CPF, telefone) e dados gerados pelo uso do aplicativo, como localização '
                    'geográfica (com sua permissão), fotos e vídeos anexados aos relatos, '
                    'e histórico de reportes enviados.',
              ),
              _buildSecao(
                '2. Uso dos Dados',
                'Suas informações são utilizadas para: identificar o usuário responsável '
                    'pelo relato, encaminhar as denúncias aos órgãos competentes, '
                    'melhorar a experiência do aplicativo, e enviar notificações sobre '
                    'o status dos seus reportes.',
              ),
              _buildSecao(
                '3. Compartilhamento',
                'Seus dados podem ser compartilhados com órgãos públicos municipais e '
                    'estaduais responsáveis pela resolução dos problemas reportados. '
                    'Não vendemos ou alugamos suas informações pessoais a terceiros.',
              ),
              _buildSecao(
                '4. Armazenamento e Segurança',
                'Adotamos medidas de segurança técnicas e organizacionais para proteger '
                    'seus dados contra acesso não autorizado, perda ou destruição. '
                    'Os dados são armazenados em servidores seguros com criptografia.',
              ),
              _buildSecao(
                '5. Seus Direitos',
                'De acordo com a LGPD (Lei Geral de Proteção de Dados), você tem direito '
                    'a: acessar seus dados pessoais, solicitar correção de dados incompletos '
                    'ou inexatos, solicitar a exclusão de seus dados, e revogar o '
                    'consentimento a qualquer momento.',
              ),
              _buildSecao(
                '6. Cookies e Tecnologias',
                'O aplicativo pode utilizar tecnologias de rastreamento para melhorar a '
                    'experiência do usuário e coletar dados analíticos sobre o uso do app.',
              ),
              _buildSecao(
                '7. Contato do DPO',
                'Para exercer seus direitos ou esclarecer dúvidas sobre esta política, '
                    'entre em contato com nosso Encarregado de Proteção de Dados pelo '
                    'e-mail: privacidade@appcidadao.com.br.',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo, String conteudo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: AppCores.neonBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            conteudo,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
