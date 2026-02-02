import 'package:flutter/material.dart';
import '../constantes/cores.dart';

class FuncoesAuxiliares {
  // Função para exibir o diálogo de Logout
  static void exibirLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppCores.lightGray,
        title: const Text('Sair do App', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: AppCores.neonBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppCores.neonBlue),
            child: const Text('SAIR'),
          ),
        ],
      ),
    );
  }

  // Função para construir o campo de busca (retorna o Widget)
  static Widget construirCampoBusca({
    required TextEditingController controller,
    required VoidCallback onClear,
  }) {
    return TextField(
      controller: controller,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Buscar serviço...',
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: onClear,
        ),
      ),
    );
  }

  // Você pode adicionar outras funções aqui futuramente, por exemplo:
  static void mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }
}
