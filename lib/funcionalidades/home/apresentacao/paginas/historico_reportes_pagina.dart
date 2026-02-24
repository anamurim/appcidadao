import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../perfil/dados/repositorios/reporte_repositorio_local.dart';
import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../dados/modelos/reporte_interferencia.dart';

class HistoricoReportesPagina extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const HistoricoReportesPagina({super.key, this.onBackToHome});

  @override
  State<HistoricoReportesPagina> createState() =>
      _HistoricoReportesPaginaState();
}

class _HistoricoReportesPaginaState extends State<HistoricoReportesPagina> {
  final _repositorio = ReporteRepositorioLocal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppCores.techGray,
      appBar: AppBar(
        title: const Text('Histórico de Reportes'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: widget.onBackToHome ?? () => Navigator.of(context).pop(),
        ),
        //backgroundColor: AppCores.deepBlue,
      ),
      body: FutureBuilder<List<ReporteBase>>(
        // Utiliza o método exato do seu repositório
        future: _repositorio.listarReportes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppCores.neonBlue),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final reportes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reportes.length,
            itemBuilder: (context, index) {
              final reporte = reportes[index];
              return _buildReporteCard(reporte);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum reporte enviado até o momento.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReporteCard(ReporteBase reporte) {
    // Verifica se é um reporte de interferência para extrair dados específicos
    final String titulo = (reporte is ReporteInterferencia)
        ? reporte.tipoInterferencia
        : "Reporte Geral";

    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppCores.neonBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.assignment_outlined,
            color: AppCores.neonBlue,
          ),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Status: ${reporte.status.name.toUpperCase()}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
            Text(
              'ID: ${reporte.id}',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onTap: () => _exibirDetalhes(reporte, titulo),
      ),
    );
  }

  void _exibirDetalhes(ReporteBase reporte, String titulo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppCores.deepBlue,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                titulo,
                style: const TextStyle(
                  color: AppCores.neonBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              if (reporte is ReporteInterferencia) ...[
                _itemDetalhe('Endereço', reporte.endereco),
                _itemDetalhe(
                  'Referência',
                  reporte.pontoReferencia ?? 'Não informado',
                ),
                _itemDetalhe('Descrição', reporte.descricao),
                if (reporte.nomeContato != null)
                  _itemDetalhe('Contato', reporte.nomeContato!),
              ],

              _itemDetalhe(
                'Status do Protocolo',
                reporte.status.name.toUpperCase(),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'VOLTAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemDetalhe(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
