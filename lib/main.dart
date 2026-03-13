<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/rotas/app_rotas.dart';
import 'core/servicos/conectividade_service.dart';
import 'core/tema/app_tema.dart';
import 'core/tema/tema_controller.dart';
import 'firebase_options.dart';
import 'funcionalidades/autenticacao/controladores/autenticacao_controller.dart';
import 'funcionalidades/home/controladores/usuario_controller.dart';
import 'funcionalidades/home/controladores/reporte_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa monitoramento de conectividade
  await ConectividadeService().inicializar();

=======
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/home_pagina.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/tema/app_tema.dart';
import 'core/tema/tema_controller.dart';
import 'funcionalidades/autenticacao/controladores/autenticacao_controller.dart';

import 'funcionalidades/home/controladores/usuario_controller.dart';
import 'funcionalidades/home/controladores/reporte_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
<<<<<<< HEAD
            initialRoute: AppRotas.login,
            onGenerateRoute: AppRotas.gerarRota,
            // Internacionalização (i18n)
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', 'US'),
            ],
            locale: const Locale('pt', 'BR'),
=======
            initialRoute: '/',
            routes: {
              '/': (context) => const TechLoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/home': (context) => const HomePagina(),
            },
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
          );
        },
      ),
    );
  }
}
