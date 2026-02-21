import 'package:flutter/material.dart';
import '../constantes/cores.dart';

class AppTema {
  // TEMA ESCURO
  static ThemeData get temaEscuro {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: AppCores.techGray,
      colorScheme: ColorScheme.dark(
        primary: AppCores.neonBlue,
        secondary: AppCores.electricBlue,
        surface: AppCores.lightGray.withValues(alpha: 0.2),
        onSurface: Colors.white,
      ),
      appBarTheme: _appBarBase.copyWith(
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // TEMA CLARO (Contraste nítido)
  static ThemeData get temaClaro {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: AppCores.deepBlue,
        secondary: AppCores.neonBlue,
        surface: Colors.grey.shade100,
        onSurface: AppCores.deepBlue, // Letras e ícones em DeepBlue
      ),
      appBarTheme: _appBarBase.copyWith(
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: AppCores.deepBlue),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static const _appBarBase = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    actionsIconTheme: IconThemeData(size: 26),
  );
}
