import 'package:flutter/material.dart';
import '../constantes/cores.dart';

class AppTema {
  static ThemeData get temaEscuro {
    return ThemeData(
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: AppCores.techGray,

      // Personalização Global da AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppCores.deepBlue,
        elevation: 0,
        //centerTitle: true,

        //Personaliza a cor e o tamanho dos ícones de ação (lupa, notificações, logout)
        actionsIconTheme: IconThemeData(
          color: Colors.white, // Todos os ícones ficam Neon Blue
          size: 26, // Tamanho padrão maior
          opacity: 0.9, // Leve transparência
        ),

        //Personaliza o ícone de "Voltar" (Leading Icon)
        iconTheme: const IconThemeData(color: Colors.white, size: 24),

        //Estilo do Texto do Título
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
