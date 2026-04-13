import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/rotas/app_rotas.dart';
//import 'core/servicos/conectividade_service.dart';
import 'core/tema/app_tema.dart';
import 'core/tema/tema_controller.dart';
import 'firebase_options.dart';
import 'funcionalidades/autenticacao/controladores/autenticacao_controller.dart';
import 'funcionalidades/home/controladores/usuario_controller.dart';
import 'funcionalidades/home/controladores/reporte_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Esta verificação impede o erro [core/duplicate-app]
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Erro ao inicializar Firebase: $e");
  }

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
            initialRoute: AppRotas.login,
            onGenerateRoute: AppRotas.gerarRota,
            // Internacionalização (i18n)
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
            locale: const Locale('pt', 'BR'),
          );
        },
      ),
    );
  }
}
