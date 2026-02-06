import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/tela_home.dart';
import 'package:appcidadao/core/tema/app_tema.dart';

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
