import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/tela_home.dart';
import 'package:appcidadao/core/tema/app_tema.dart';
import 'package:appcidadao/core/tema/tema_controller.dart'; // Importe o controller

void main() {
  runApp(const AppCidadao());
}

class AppCidadao extends StatelessWidget {
  const AppCidadao({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças no TemaController
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: TemaController.instance,
      builder: (context, temaAtual, child) {
        return MaterialApp(
          title: 'App Cidadão',
          debugShowCheckedModeBanner: false,

          // Configurações de Tema
          themeMode: temaAtual, // Usa o tema atual do controller
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            // Adicione outras customizações para o tema claro aqui
          ),
          darkTheme:
              AppTema.temaEscuro, // Usa o tema escuro que você já definiu

          initialRoute: '/',
          routes: {
            '/': (context) => const TechLoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/signup': (context) => const SignupScreen(),
          },
        );
      },
    );
  }
}
