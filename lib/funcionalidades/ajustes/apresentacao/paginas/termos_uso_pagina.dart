import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class TelaTermosUso extends StatelessWidget {
  const TelaTermosUso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Termos de Uso',
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
                'Termos de Uso do App Cidadão',
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
                '1. Aceitação dos Termos',
                'Ao utilizar o App Cidadão, você concorda com estes Termos de Uso. '
                    'Caso não concorde com alguma disposição, não utilize o aplicativo. '
                    'O uso contínuo do aplicativo constitui aceitação de quaisquer modificações '
                    'posteriores destes termos.',
              ),
              _buildSecao(
                '2. Descrição do Serviço',
                'O App Cidadão é uma plataforma digital que permite aos cidadãos reportar '
                    'problemas urbanos como interferências na via, semáforos com defeito, '
                    'veículos abandonados, estacionamento irregular, problemas de sinalização '
                    'e iluminação pública. Os relatos são encaminhados aos órgãos competentes '
                    'para providências.',
              ),
              _buildSecao(
                '3. Cadastro e Conta',
                'Para utilizar o aplicativo, é necessário criar uma conta fornecendo '
                    'informações pessoais verdadeiras e atualizadas. Você é responsável '
                    'por manter a confidencialidade de sua senha e por todas as atividades '
                    'realizadas em sua conta.',
              ),
              _buildSecao(
                '4. Uso Adequado',
                'O usuário se compromete a utilizar o aplicativo apenas para reportar '
                    'problemas reais e legítimos. É proibido enviar relatos falsos, '
                    'conteúdo ofensivo, discriminatório ou que viole a legislação vigente. '
                    'O uso indevido pode resultar no bloqueio ou exclusão da conta.',
              ),
              _buildSecao(
                '5. Propriedade Intelectual',
                'Todo o conteúdo do App Cidadão, incluindo design, textos, gráficos, '
                    'logotipos e software, é protegido por direitos autorais e não pode '
                    'ser reproduzido sem autorização prévia.',
              ),
              _buildSecao(
                '6. Limitação de Responsabilidade',
                'O App Cidadão atua como intermediário entre cidadãos e órgãos públicos. '
                    'Não garantimos prazos de resolução dos problemas reportados. '
                    'O aplicativo é fornecido "como está", sem garantias de qualquer tipo.',
              ),
              _buildSecao(
                '7. Contato',
                'Para dúvidas ou esclarecimentos sobre estes Termos de Uso, '
                    'entre em contato pelo e-mail suporte@appcidadao.com.br.',
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
