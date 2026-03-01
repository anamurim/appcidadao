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
        //backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: AppCores.neonBlue),
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Termos de Uso do App Cidadão',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Última atualização: 23 de Fevereiro de 2026',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _buildSecao(
                context,
                '1. Aceitação dos Termos',
                'Ao utilizar o App Cidadão, você concorda com estes Termos de Uso. '
                    'Caso não concorde com alguma disposição, não utilize o aplicativo. '
                    'O uso contínuo do aplicativo constitui aceitação de quaisquer modificações '
                    'posteriores destes termos.',
              ),
              _buildSecao(
                context,
                '2. Descrição do Serviço',
                'O App Cidadão é uma plataforma digital que permite aos cidadãos reportar '
                    'problemas urbanos como interferências na via, semáforos com defeito, '
                    'veículos abandonados, estacionamento irregular, problemas de sinalização '
                    'e iluminação pública. Os relatos são encaminhados aos órgãos competentes '
                    'para providências.',
              ),
              _buildSecao(
                context,
                '3. Cadastro e Conta',
                'Para utilizar o aplicativo, é necessário criar uma conta fornecendo '
                    'informações pessoais verdadeiras e atualizadas. Você é responsável '
                    'por manter a confidencialidade de sua senha e por todas as atividades '
                    'realizadas em sua conta.',
              ),
              _buildSecao(
                context,
                '4. Uso Adequado',
                'O usuário se compromete a utilizar o aplicativo apenas para reportar '
                    'problemas reais e legítimos. É proibido enviar relatos falsos, '
                    'conteúdo ofensivo, discriminatório ou que viole a legislação vigente. '
                    'O uso indevido pode resultar no bloqueio ou exclusão da conta.',
              ),
              _buildSecao(
                context,
                '5. Propriedade Intelectual',
                'Todo o conteúdo do App Cidadão, incluindo design, textos, gráficos, '
                    'logotipos e software, é protegido por direitos autorais e não pode '
                    'ser reproduzido sem autorização prévia.',
              ),
              _buildSecao(
                context,
                '6. Limitação de Responsabilidade',
                'O App Cidadão atua como intermediário entre cidadãos e órgãos públicos. '
                    'Não garantimos prazos de resolução dos problemas reportados. '
                    'O aplicativo é fornecido "como está", sem garantias de qualquer tipo.',
              ),
              _buildSecao(
                context,
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

  Widget _buildSecao(BuildContext context, String titulo, String conteudo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            conteudo,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
