import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:appcidadao/funcionalidades/autenticacao/interface/telalogin.dart';
=======
//import 'package:appcidadao/funcionalidades/autenticacao/interface/telalogin.dart';
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
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
<<<<<<< HEAD
        '/': (context) => const TechLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/signup': (context) => const SignupScreen(),
=======
        //'/': (context) => const TechLoginScreen(), //Tela inicial verdadeira
        '/': (context) => const HomeScreen(), //Apagar após corrigir telahome
        '/home': (context) => const HomeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/signup': (context) => const SignupScreen(), // Adicionar quando criado
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
      },
    );
  }
}
