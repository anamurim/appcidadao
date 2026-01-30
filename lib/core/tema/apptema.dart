import 'package:flutter/material.dart';
import '../constantes/cores.dart';

class AppTema {
  static ThemeData get temaEscuro {
    return ThemeData(
      fontFamily: 'Segoe UI',
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: AppCores.techGray,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
