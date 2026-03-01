import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import 'package:appcidadao/funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/home_pagina.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/repositorios/reporte_repositorio_com_fallback.dart';
import 'core/repositorios/usuario_repositorio_com_fallback.dart';
import 'core/tema/app_tema.dart';
import 'core/tema/tema_controller.dart';
import 'firebase_options.dart';
import 'funcionalidades/autenticacao/controladores/autenticacao_controller.dart';
import 'funcionalidades/home/controladores/usuario_controller.dart';
import 'funcionalidades/home/controladores/reporte_controller.dart';

/// Chave global para exibir SnackBars de fallback de qualquer lugar.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tenta inicializar o Firebase.
  // Se falhar (ex: firebase_options.dart com placeholder, sem internet),
  // o app continua funcionando em modo local.
  bool firebaseOk = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseOk = true;
    debugPrint('✅ Firebase inicializado com sucesso.');
  } catch (e) {
    debugPrint('⚠️ Firebase não inicializado — usando modo local: $e');
  }

  runApp(AppCidadao(firebaseDisponivel: firebaseOk));
}

class AppCidadao extends StatelessWidget {
  final bool firebaseDisponivel;

  const AppCidadao({super.key, this.firebaseDisponivel = false});

  @override
  Widget build(BuildContext context) {
    // Callback para mostrar SnackBar quando o fallback local é ativado.
    void mostrarFalhaConexao(String mensagem) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(mensagem)),
            ],
          ),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AutenticacaoController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsuarioController(
            repositorio: UsuarioRepositorioComFallback(
              onFalhaConexao: mostrarFalhaConexao,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ReporteController(
            repositorio: ReporteRepositorioComFallback(
              onFalhaConexao: mostrarFalhaConexao,
            ),
          ),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: TemaController.instance,
        builder: (context, modoTema, _) {
          return MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
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
              '/home': (context) => const HomePagina(),
            },
          );
        },
      ),
    );
  }
}
