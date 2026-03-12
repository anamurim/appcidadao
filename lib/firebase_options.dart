import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opções padrão de configuração do Firebase.
///
/// ⚠️  PLACEHOLDER — Substitua este arquivo pelo gerado automaticamente:
///
///   1. Instale o FlutterFire CLI:
///      dart pub global activate flutterfire_cli
///
///   2. Execute no terminal, na raiz do projeto:
///      flutterfire configure
///
///   3. O comando vai sobrescrever este arquivo com as credenciais reais
///      do seu projeto Firebase.
///
/// Enquanto não fizer isso, o Firebase NÃO inicializará e o app funcionará
/// em modo local (fallback automático).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions não foi configurado para Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não suporta esta plataforma.',
        );
    }
  }

  // ======================================================================
  // VALORES PLACEHOLDER — serão substituídos por `flutterfire configure`
  // ======================================================================

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUA_API_KEY_AQUI',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'SUA_API_KEY_AQUI',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'SUA_API_KEY_AQUI',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
    iosBundleId: 'com.example.appcidadao',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'SUA_API_KEY_AQUI',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
    iosBundleId: 'com.example.appcidadao',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'SUA_API_KEY_AQUI',
    appId: 'SEU_APP_ID_AQUI',
    messagingSenderId: 'SEU_SENDER_ID_AQUI',
    projectId: 'SEU_PROJECT_ID_AQUI',
    storageBucket: 'SEU_STORAGE_BUCKET_AQUI',
  );
}
