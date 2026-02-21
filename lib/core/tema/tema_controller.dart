import 'package:flutter/material.dart';

class TemaController extends ValueNotifier<ThemeMode> {
  TemaController._() : super(ThemeMode.system);
  static final instance = TemaController._();

  void mudarTema(ThemeMode novoTema) {
    value = novoTema;
    notifyListeners(); // Essencial para atualizar o app
  }
}
