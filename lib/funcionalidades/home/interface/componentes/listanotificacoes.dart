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
    // Pegando as notificações reais do DadosHome
    final lista = DadosHome.notifications;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8, // Começa ocupando 80% da tela
      maxChildSize: 0.95, // Pode expandir até 95%
      minChildSize: 0.5, // Pode encolher até 50%
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent, // Para manter a cor do Container abaixo
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppCores.lightGray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                // Indicador visual de "puxar" no topo
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Cabeçalho do Painel
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
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de Notificações com scroll controlado
                Expanded(
                  child: ListView.builder(
                    controller:
                        scrollController, // Importante para o arraste funcionar
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final item = lista[index];
                      final bool isUnread = item['read'] == false;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppCores.techGray, // Cor interna dos cards
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isUnread
                                ? AppCores.neonBlue.withValues(alpha: 0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.notifications,
                              color: isUnread
                                  ? AppCores.neonBlue
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['message'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Botão Inferior
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppCores.techGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Lógica para marcar como lidas (exemplo)
                        setState(() {
                          for (var n in lista) {
                            n['read'] = true;
                          }
                        });
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
