import 'package:flutter/material.dart';

class TemaController extends ValueNotifier<ThemeMode> {
  // Construtor privado para Singleton
  TemaController._() : super(ThemeMode.system);

  // Instância única para ser acessada em todo o app
  static final instance = TemaController._();

  // Função para alterar o tema globalmente
  void mudarTema(ThemeMode novoTema) {
    value = novoTema;
  }
}
