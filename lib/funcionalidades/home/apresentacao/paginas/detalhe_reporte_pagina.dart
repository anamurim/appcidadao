import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/reporte_status.dart';
import '../../../../core/modelos/media_item.dart';
import '../../../../core/widgets/media_preview_grid.dart';

class DetalheReportePagina extends StatelessWidget {
  final ReporteBase reporte;

  const DetalheReportePagina({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Reporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com Tipo e Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reporte.tipoReporte,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                _buildStatusBadge(reporte.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${reporte.id}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const Divider(height: 32),

            // Localização
            _buildInfoSection(
              context,
              icon: Icons.location_on,
              label: 'Localização',
              content: reporte.endereco,
            ),

            if (reporte.pontoReferencia != null &&
                reporte.pontoReferencia!.isNotEmpty)
              _buildInfoSection(
                context,
                icon: Icons.pin_drop,
                label: 'Ponto de Referência',
                content: reporte.pontoReferencia!,
              ),

            // Descrição
            _buildInfoSection(
              context,
              icon: Icons.description,
              label: 'Descrição',
              content: reporte.descricao,
            ),

            // Data
            _buildInfoSection(
              context,
              icon: Icons.calendar_today,
              label: 'Data da Solicitação',
              content: _formatFullDate(reporte.dataCriacao),
            ),

            const SizedBox(height: 12),

            // Mídias (reutilizando seu widget MediaPreviewGrid)
            if (reporte.midias.isNotEmpty) ...[
              Text(
                'Anexos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              MediaPreviewGrid(
                midias: reporte.midias
                    .map(
                      (m) => MediaItem(
                        filePath: null,
                        url: m.url,
                        type: m.type,
                        nomeArquivo: null,
                      ),
                    )
                    .toList(),
                onChanged: (_) {}, // Somente leitura
                editavel: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppCores.neonBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ReporteStatus status) {
    // Lógica de cores baseada no seu código original em historico_reportes_pagina.dart
    Color color;
    switch (status) {
      case ReporteStatus.pendente:
        color = Colors.orange;
        break;
      case ReporteStatus.enviado:
        color = Colors.yellow[800]!;
        break;
      case ReporteStatus.emAnalise:
        color = Colors.blue;
        break;
      case ReporteStatus.rejeitado:
        color = Colors.red;
        break;
      case ReporteStatus.resolvido:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.name.toUpperCase(), // Ou use seu _statusToString
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
