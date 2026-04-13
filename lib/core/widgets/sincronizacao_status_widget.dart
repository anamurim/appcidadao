import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../funcionalidades/home/controladores/reporte_controller.dart';

/// Widget que monitora e exibe o status de sincronização de reportes.
///
/// Mostra:
/// - Badge com número de reportes pendentes
/// - Indicador de sincronização em progresso
/// - Mensagens de erro (se houver)
/// - Botão para forçar sincronização manual
class SincronizacaoStatusWidget extends StatelessWidget {
  final bool compact; // Modo compacto (apenas badge) ou expandido

  const SincronizacaoStatusWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReporteController>(
      builder: (context, controller, _) {
        // Se não há pendentes e não está sincronizando, não mostra nada
        if (controller.reportesPendentes == 0 && !controller.sincronizando) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);

        // Modo compacto: apenas badge
        if (compact) {
          if (controller.reportesPendentes == 0) {
            return const SizedBox.shrink();
          }

          return Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${controller.reportesPendentes}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // Modo expandido: card com detalhes
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (controller.sincronizando)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            theme.colorScheme.primary,
                          ),
                        ),
                      )
                    else if (controller.reportesPendentes > 0)
                      Icon(
                        Icons.warning_rounded,
                        color: theme.colorScheme.error,
                        size: 16,
                      )
                    else
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.sincronizando)
                            Text(
                              'Sincronizando reportes...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else if (controller.reportesPendentes > 0)
                            Text(
                              '${controller.reportesPendentes} reporte(s) pendente(s)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.error,
                              ),
                            )
                          else
                            Text(
                              'Tudo sincronizado',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (controller.errorMessage != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              controller.errorMessage!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (controller.reportesPendentes > 0 &&
                    !controller.sincronizando) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () async {
                        await controller.forcarSincronizacao();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Sincronização iniciada',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Sincronizar agora'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Badge simples com contador de pendentes.
class PendentesCounterBadge extends StatelessWidget {
  const PendentesCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReporteController>(
      builder: (context, controller, _) {
        if (controller.reportesPendentes == 0) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        return Chip(
          label: Text('${controller.reportesPendentes} pendente(s)'),
          backgroundColor: theme.colorScheme.errorContainer,
          labelStyle: TextStyle(color: theme.colorScheme.onErrorContainer),
          avatar: Icon(
            Icons.pending_actions,
            color: theme.colorScheme.onErrorContainer,
            size: 18,
          ),
        );
      },
    );
  }
}
