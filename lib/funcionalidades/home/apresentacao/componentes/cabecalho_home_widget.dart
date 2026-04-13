import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importante para o context.watch
import '../../../../core/constantes/cores.dart';
import '../../../perfil/tela_perfil.dart';
import 'package:appcidadao/funcionalidades/home/controladores/usuario_controller.dart';

class CabecalhoHome extends StatelessWidget {
  const CabecalhoHome({super.key});

  @override
  Widget build(BuildContext context) {
    // O context.watch faz o widget reconstruir sempre que notifyListeners() for chamado no controller
    final usuarioController = context.watch<UsuarioController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppCores.deepBlue, AppCores.electricBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppCores.electricBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar do Usuário
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppCores.neonBlue, width: 2),
                    // Se o avatar for uma URL de imagem, você pode usar DecorationImage aqui
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppCores.deepBlue,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaPerfil(
                            onBackToHome: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Informações de Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome dinâmico
                      Text(
                        'Olá, ${usuarioController.nome}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email dinâmico
                      Text(
                        usuarioController.email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Badge da Conta (Descomentei para usar o dado real)
                      /*Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppCores.neonBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppCores.neonBlue,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Conta: ${usuarioController.conta}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                // Feedback visual de carregamento (opcional)
                if (usuarioController.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
