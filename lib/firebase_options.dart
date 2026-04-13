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
    apiKey: 'AIzaSyC93zSUOP6yskfVE-cXnnw3khrfiwIX1w8',
    appId: '1:482276991152:web:475f2c898c1ab0be93db75',
    messagingSenderId: '482276991152',
    projectId: 'appcidadao-e7943',
    authDomain: 'appcidadao-e7943.firebaseapp.com',
    storageBucket: 'appcidadao-e7943.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8crIBFAAMobkd-U4A8ixjpxURDlapLtA',
    appId: '1:482276991152:android:26121e4221b1238e93db75',
    messagingSenderId: '482276991152',
    projectId: 'appcidadao-e7943',
    storageBucket: 'appcidadao-e7943.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAow6ikecpLESzttfV8c-aJ07cdpcaqTiM',
    appId: '1:482276991152:ios:54701dd8b6e13a5593db75',
    messagingSenderId: '482276991152',
    projectId: 'appcidadao-e7943',
    storageBucket: 'appcidadao-e7943.firebasestorage.app',
    iosBundleId: 'com.example.appcidadao',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAow6ikecpLESzttfV8c-aJ07cdpcaqTiM',
    appId: '1:482276991152:ios:54701dd8b6e13a5593db75',
    messagingSenderId: '482276991152',
    projectId: 'appcidadao-e7943',
    storageBucket: 'appcidadao-e7943.firebasestorage.app',
    iosBundleId: 'com.example.appcidadao',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC93zSUOP6yskfVE-cXnnw3khrfiwIX1w8',
    appId: '1:482276991152:web:a05f5e382fae5d4493db75',
    messagingSenderId: '482276991152',
    projectId: 'appcidadao-e7943',
    authDomain: 'appcidadao-e7943.firebaseapp.com',
    storageBucket: 'appcidadao-e7943.firebasestorage.app',
  );

}