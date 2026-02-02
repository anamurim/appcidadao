import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../dados/dadoshome.dart';

class NotificacoesLista extends StatelessWidget {
  final ScrollController? scrollController;
  final bool compacta;

  const NotificacoesLista({
    super.key,
    this.scrollController,
    this.compacta = false,
  });

  @override
  Widget build(BuildContext context) {
    // Pegamos a fonte de dados centralizada
    final lista = DadosHome.notifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho da seção
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notificações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => exibirTodasNotificacoes(context),
              child: const Text(
                'Ver todas',
                style: TextStyle(color: AppCores.neonBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // A lista propriamente dita
        ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          physics: scrollController == null
              ? const NeverScrollableScrollPhysics()
              : null,
          itemCount: compacta
              ? (lista.length > 2 ? 2 : lista.length)
              : lista.length,
          itemBuilder: (context, index) {
            final notification = lista[index];
            return _buildNotificationItem(notification);
          },
        ),
      ],
    );
  }

  static void exibirTodasNotificacoes(BuildContext context) {
    _exibirNotificacoes(context);
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final bool isUnread = notification['read'] == false;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? AppCores.neonBlue.withValues(alpha: 0.3)
              : Colors.transparent,
          width: isUnread ? 2 : 0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: isUnread ? AppCores.neonBlue : Colors.transparent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] ?? 'Sem título',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            notification['time'] ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  static void _exibirNotificacoes(BuildContext context) {
    final lista = DadosHome.notifications;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppCores.lightGray,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final notification = lista[index];
                        return _buildModalItem(notification);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMarcarLidasButton(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildModalItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.techGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications,
            color: !(notification['read'] ?? true)
                ? AppCores.neonBlue
                : Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification['time'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMarcarLidasButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppCores.techGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            // Lógica para marcar como lidas
          },
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'MARCAR TODAS COMO LIDAS',
                style: TextStyle(
                  color: AppCores.neonBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
