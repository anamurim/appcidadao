import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/autenticacao/interface/telalogin.dart';
import 'funcionalidades/autenticacao/interface/telarecuperacaosenha.dart';
import 'funcionalidades/autenticacao/interface/telacadastro.dart';
import 'package:appcidadao/funcionalidades/home/interface/telahome.dart';
import 'core/tema/apptema.dart';

void main() {
  runApp(const AppCidadao());
}

class AppCidadao extends StatelessWidget {
  const AppCidadao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cidadão',
      debugShowCheckedModeBanner: false,
      theme: AppTema.temaEscuro,
      initialRoute: '/',
      routes: {
        '/': (context) => const TechLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
