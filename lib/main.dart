import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/home_pagina.dart';
import 'package:appcidadao/core/tema/app_tema.dart';
import 'package:appcidadao/funcionalidades/autenticacao/controladores/autenticacao_controller.dart';
import 'package:appcidadao/funcionalidades/home/controladores/reporte_controller.dart';
import 'package:appcidadao/funcionalidades/home/controladores/usuario_controller.dart';

void main() {
  runApp(const AppCidadao());
}

class AppCidadao extends StatelessWidget {
  const AppCidadao({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacaoController()),
        ChangeNotifierProvider(
          create: (_) => UsuarioController()..carregarUsuario(),
        ),
        ChangeNotifierProvider(create: (_) => ReporteController()),
      ],
      child: MaterialApp(
        title: 'App Cidadão',
        debugShowCheckedModeBanner: false,
        theme: AppTema.temaEscuro,
        initialRoute: '/',
        routes: {
          '/': (context) => const TechLoginScreen(),
          '/home': (context) => const HomePagina(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/signup': (context) => const SignupScreen(),
        },
      ),
    );
  }
}
