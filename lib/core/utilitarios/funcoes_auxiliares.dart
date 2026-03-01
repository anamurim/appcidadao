import 'package:flutter/material.dart';
import '../constantes/cores.dart';

class FuncoesAuxiliares {
  // Função genérica de Logout
  static void exibirLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Sair do App',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCELAR',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Volta para a tela de login removendo o histórico
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppCores.neonBlue),
            child: const Text('SAIR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget do Campo de Busca (Componente visual reutilizável)
  static Widget construirCampoBusca({
    required TextEditingController controller,
    required VoidCallback onClear,
    required Function(String) onChanged,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Buscar funcionalidades...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppCores.neonBlue),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.7)),
            onPressed: onClear,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
