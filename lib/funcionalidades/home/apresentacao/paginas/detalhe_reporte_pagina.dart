import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/reporte_status.dart';
import '../../../../core/widgets/media_preview_grid.dart';

class DetalheReportePagina extends StatelessWidget {
  final ReporteBase reporte;

  const DetalheReportePagina({super.key, required this.reporte});

  // Função para capitalizar apenas a primeira letra (solicitado anteriormente)
  String _capitalize(String text) {
    if (text.isEmpty) return "";
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, // Fundo limpo
      appBar: AppBar(
        title: const Text(
          'Detalhes do Reporte',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppCores.deepBlue,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppCores.neonBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Tipo e Status em um Card de destaque
            _buildHeaderCard(context),

            const SizedBox(height: 32),

            _buildSectionTitle(context, 'LOCALIZAÇÃO'),
            _buildInfoCard(
              content: reporte.endereco,
              subContent: reporte.pontoReferencia?.isNotEmpty == true
                  ? "Ponto de referência: ${reporte.pontoReferencia}"
                  : null,
              icon: Icons.location_on_rounded,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(context, 'DESCRIÇÃO DO INCIDENTE'),
            _buildDescriptionBox(context, reporte.descricao),

            const SizedBox(height: 24),

            // Mídias com layout de galeria
            if (reporte.midias.isNotEmpty) ...[
              _buildSectionTitle(context, 'EVIDÊNCIAS ANEXADAS'),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MediaPreviewGrid(
                  midias: reporte.midias,
                  editavel: false,
                  altura: 140,
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Rodapé com Timeline/Data sutil
            Center(
              child: Text(
                'Registrado em ${_formatFullDate(reporte.dataCriacao)}',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppCores.neonBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalize(reporte.tipoReporte),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID do Protocolo: #${reporte.id.substring(0, 8).toUpperCase()}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(reporte.status),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 1.0),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String content,
    String? subContent,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppCores.neonBlue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content, style: const TextStyle(fontSize: 16, height: 1.4)),
              if (subContent != null)
                Text(
                  subContent,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionBox(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  // Reutilizando seu Badge, mas com fontes menores e mais clean
  Widget _buildStatusBadge(ReporteStatus status) {
    Color color;
    String texto;

    switch (status) {
      case ReporteStatus.pendente:
        color = Colors.orange;
        texto = 'PENDENTE';
        break;
      case ReporteStatus.enviado:
        color = Colors.blue;
        texto = 'ENVIADO';
        break;
      case ReporteStatus.emAnalise:
        color = Colors.purple;
        texto = 'EM ANÁLISE';
        break;
      case ReporteStatus.rejeitado:
        color = Colors.red;
        texto = 'REJEITADO';
        break;
      case ReporteStatus.resolvido:
        color = Colors.green;
        texto = 'RESOLVIDO';
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
        texto,
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
