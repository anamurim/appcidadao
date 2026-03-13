import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handler de background para mensagens push (deve ser top-level).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📩 Mensagem em background: ${message.notification?.title}');
}

/// Serviço de notificações push via Firebase Cloud Messaging (FCM).
///
/// Responsável por:
/// - Solicitar permissão de notificações
/// - Obter e logar o token FCM
/// - Escutar mensagens em foreground e background
class NotificacaoService {
  static final NotificacaoService _instancia = NotificacaoService._interno();

  factory NotificacaoService() => _instancia;
  NotificacaoService._interno();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Inicializa o serviço de notificações.
  ///
  /// Deve ser chamado após `Firebase.initializeApp()`.
  Future<void> inicializar() async {
    // Registra handler de background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Solicita permissão
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ Permissão de notificação concedida');
    } else {
      debugPrint('❌ Permissão de notificação negada');
      return;
    }

    // Obtém token FCM
    final token = await _messaging.getToken();
    debugPrint('🔑 Token FCM: $token');

    // Escuta mensagens em foreground
    FirebaseMessaging.onMessage.listen(_onMensagemForeground);

    // Escuta quando o usuário toca na notificação
    FirebaseMessaging.onMessageOpenedApp.listen(_onMensagemAberta);

    // Verifica se o app foi aberto via notificação
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _onMensagemAberta(initialMessage);
    }
  }

  void _onMensagemForeground(RemoteMessage message) {
    debugPrint(
      '📩 Mensagem foreground: ${message.notification?.title} — '
      '${message.notification?.body}',
    );
    // TODO: Exibir SnackBar ou dialog com a notificação
  }

  void _onMensagemAberta(RemoteMessage message) {
    debugPrint(
      '👆 Notificação tocada: ${message.notification?.title}',
    );
    // TODO: Navegar para a tela do reporte correspondente
  }
}
