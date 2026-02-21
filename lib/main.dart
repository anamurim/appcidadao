import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/home_pagina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importe seus controllers (ajuste os caminhos conforme seu projeto)
import 'core/tema/app_tema.dart';
import 'core/tema/tema_controller.dart';
import 'funcionalidades/autenticacao/controladores/autenticacao_controller.dart';

// Certifique-se de importar estes abaixo:
import 'funcionalidades/home/controladores/usuario_controller.dart';
import 'funcionalidades/home/controladores/reporte_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppCidadao());
}

class AppCidadao extends StatelessWidget {
  const AppCidadao({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutenticacaoController()),

        ChangeNotifierProvider(create: (_) => UsuarioController()),
        ChangeNotifierProvider(create: (_) => ReporteController()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: TemaController.instance,
        builder: (context, modoTema, _) {
          return MaterialApp(
            title: 'Equatorial App Cidadão',
            debugShowCheckedModeBanner: false,
            theme: AppTema.temaClaro,
            darkTheme: AppTema.temaEscuro,
            themeMode: modoTema,
            initialRoute: '/',
            routes: {
              '/': (context) => const TechLoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              //Adicione a rota da Home se necessário
              '/home': (context) => const HomePagina(),
            },
          );
        },
      ),
    );
  }
}
