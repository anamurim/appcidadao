import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class TelaDispositivosConectados extends StatelessWidget {
  const TelaDispositivosConectados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dispositivos Conectados',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            AppCores.deepBlue, // Padrão da sua tela de configurações
        iconTheme: const IconThemeData(
          color: AppCores.neonBlue,
        ), // Ícones em neon azul para consistência
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray, // Padrão do seu app
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                'ONDE VOCÊ ESTÁ CONECTADO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Dispositivo Atual
            _buildDispositivoItem(
              context,
              aparelho: 'Este iPhone 15 Pro (Atual)',
              localizacao: 'São Luís, Brasil',
              data: 'Ativo agora',
              icon: Icons.smartphone_rounded,
              isAtual: true,
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                'OUTRAS SESSÕES ATIVAS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Exemplo de outro dispositivo
            _buildDispositivoItem(
              context,
              aparelho: 'Windows PC - Chrome',
              localizacao: 'São Paulo, Brasil',
              data: 'Último acesso: 05 de Fev às 14:20',
              icon: Icons.computer_rounded,
            ),

            _buildDispositivoItem(
              context,
              aparelho: 'Samsung Galaxy S23',
              localizacao: 'Rio de Janeiro, Brasil',
              data: 'Último acesso: 01 de Fev às 09:15',
              icon: Icons.smartphone_rounded,
            ),

            const SizedBox(height: 40),

            // Opção para encerrar todas as outras sessões
            Center(
              child: TextButton(
                onPressed: () => _confirmarLogoutGeral(context),
                child: const Text(
                  'Encerrar todas as outras sessões',
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

  Widget _buildDispositivoItem(
    BuildContext context, {
    required String aparelho,
    required String localizacao,
    required String data,
    required IconData icon,
    bool isAtual = false,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isAtual
              ? AppCores.neonBlue.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.1),
          width: isAtual ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppCores.electricBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppCores.electricBlue),
        ),
        title: Text(
          aparelho,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('$localizacao • $data', style: const TextStyle(fontSize: 13)),
          ],
        ),
        trailing: isAtual
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _confirmarEncerramento(context, aparelho),
              ),
      ),
    );
  }

  void _confirmarEncerramento(BuildContext context, String aparelho) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              AppCores.lightGray, // Padrão do seu diálogo de carregamento
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Encerrar Sessão?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Deseja realmente desconectar sua conta do dispositivo $aparelho?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Aqui entraria a lógica de API para deslogar
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sessão em $aparelho encerrada.')),
                );
              },
              child: const Text(
                'ENCERRAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmarLogoutGeral(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppCores
              .lightGray, // Mantendo o padrão do seu telacadastrouser.dart
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Text(
                'Atenção',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Isso fará com que sua conta seja desconectada de todos os aparelhos, exceto deste que você está usando agora. Continuar?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCores
                    .deepBlue, // Usando sua cor principal para ação em massa
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Lógica para invalidar todos os tokens/sessões via API
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Desconectado de todos os outros dispositivos.',
                    ),
                    backgroundColor: AppCores.electricBlue,
                  ),
                );
              },
              child: const Text(
                'CONFIRMAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
