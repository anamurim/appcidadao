import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../dados/dadoshome.dart';

class NotificacoesPanel extends StatefulWidget {
  const NotificacoesPanel({super.key});

  @override
  State<NotificacoesPanel> createState() => _NotificacoesPanelState();
}

class _NotificacoesPanelState extends State<NotificacoesPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray,
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: AppCores.deepBlue,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: DadosHome.notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notificacao = DadosHome.notifications[index];
          final bool isRead = notificacao['read'];

          return ListTile(
            tileColor: isRead
                ? AppCores.lightGray.withValues(alpha: 0.3)
                : AppCores.lightGray.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: CircleAvatar(
              backgroundColor: isRead ? Colors.grey : AppCores.neonBlue,
              child: Icon(
                isRead ? Icons.notifications_none : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            title: Text(
              notificacao['title'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notificacao['message'],
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  notificacao['time'],
                  style: const TextStyle(
                    color: AppCores.neonBlue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                DadosHome.markAsRead(notificacao['id']);
              });
            },
          );
        },
      ),
    );
  }
}
