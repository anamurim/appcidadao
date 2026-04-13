import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/reporte_status.dart';
//import '../../../../core/widgets/media_preview_grid.dart';
//import '../../../../core/modelos/media_item.dart';
import '../../controladores/reporte_controller.dart';
import 'detalhe_reporte_pagina.dart';

class HistoricoReportesPagina extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const HistoricoReportesPagina({super.key, this.onBackToHome});

  @override
  State<HistoricoReportesPagina> createState() =>
      _HistoricoReportesPaginaState();
}

class _HistoricoReportesPaginaState extends State<HistoricoReportesPagina> {
  final _searchController = TextEditingController();
  String? _filtroTipo;
  ReporteStatus? _filtroStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteController>().carregarReportes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra os reportes com base na busca e filtros ativos.
  List<ReporteBase> _filtrarReportes(List<ReporteBase> reportes) {
    var resultado = reportes;

    // Filtro por texto (busca)
    final query = _searchController.text.toLowerCase().trim();
    if (query.isNotEmpty) {
      resultado = resultado.where((r) {
        return r.endereco.toLowerCase().contains(query) ||
            r.descricao.toLowerCase().contains(query) ||
            r.tipoReporte.toLowerCase().contains(query) ||
            r.id.contains(query);
      }).toList();
    }

    // Filtro por tipo de reporte
    if (_filtroTipo != null) {
      resultado = resultado.where((r) => r.tipoReporte == _filtroTipo).toList();
    }

    // Filtro por status
    if (_filtroStatus != null) {
      resultado = resultado.where((r) => r.status == _filtroStatus).toList();
    }

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Reportes'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: widget.onBackToHome ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ReporteController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar reportes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.carregarReportes(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final reportesFiltrados = _filtrarReportes(controller.reportes);

          return Column(
            children: [
              // ── Barra de busca ──
              _buildSearchBar(),

              // ── Filtros por tipo ──
              _buildFiltrosTipo(controller.reportes),

              // ── Filtros por status ──
              _buildFiltrosStatus(),

              // ── Lista de reportes ──
              Expanded(
                child: reportesFiltrados.isEmpty
                    ? _buildEmptyState()
                    : // ── Lista de reportes ──
                      Expanded(
                        child: reportesFiltrados.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: reportesFiltrados.length,
                                itemBuilder: (context, index) {
                                  final reporte = reportesFiltrados[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      // Título principal (Tipo do Reporte)
                                      title: Text(
                                        reporte.tipoReporte,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      // Subtítulo (Endereço e Data)
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            reporte.endereco,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(reporte.dataCriacao),
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Badge de Status à direita
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildStatusChip(reporte.status),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: AppCores.neonBlue,
                                          ),
                                        ],
                                      ),
                                      // Ação de clicar no item todo (igual ao seu código de livros)
                                      onTap: () => _abrirDetalhesReporte(
                                        context,
                                        reporte,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Buscar reportes...',
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: AppCores.lightGray.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFiltrosTipo(List<ReporteBase> todosReportes) {
    // Extrai tipos únicos dos reportes existentes
    final tiposUnicos = todosReportes.map((r) => r.tipoReporte).toSet().toList()
      ..sort();

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Chip "Todos"
          FilterChip(
            label: const Text('Todos'),
            selected: _filtroTipo == null,
            onSelected: (selected) {
              setState(() => _filtroTipo = selected ? null : _filtroTipo);
            },
          ),
          const SizedBox(width: 8),
          // Chips para cada tipo
          ...tiposUnicos.map(
            (tipo) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(tipo),
                selected: _filtroTipo == tipo,
                onSelected: (selected) {
                  setState(() => _filtroTipo = selected ? tipo : null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltrosStatus() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Chip "Todos"
          FilterChip(
            label: const Text('Todos'),
            selected: _filtroStatus == null,
            onSelected: (selected) {
              setState(() => _filtroStatus = selected ? null : _filtroStatus);
            },
          ),
          const SizedBox(width: 8),
          // Chips para cada status
          ...ReporteStatus.values.map(
            (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_statusToString(status)),
                selected: _filtroStatus == status,
                onSelected: (selected) {
                  setState(() => _filtroStatus = selected ? status : null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum reporte encontrado',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os filtros ou criar um novo reporte',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /*Widget _buildReporteCard(ReporteBase reporte) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com tipo e status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reporte.tipoReporte,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(reporte.status),
              ],
            ),
            const SizedBox(height: 8),

            // Descrição
            Text(
              reporte.descricao,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Endereço
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reporte.endereco,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Data e ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(reporte.dataCriacao),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  'ID: ${reporte.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),

            // Mídias se existirem
            if (reporte.midias.isNotEmpty) ...[
              const SizedBox(height: 12),
              MediaPreviewGrid(
                midias: reporte.midias
                    .map(
                      (m) => MediaItem(
                        filePath: null,
                        url: m.url,
                        type: m.type == MediaType.image
                            ? MediaType.image
                            : MediaType.video,
                        nomeArquivo: null,
                      ),
                    )
                    .toList(),
                onChanged: (_) {}, // Read-only
                editavel: false,
              ),
            ],
          ],
        ),
      ),
    );
  }*/

  Widget _buildStatusChip(ReporteStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ReporteStatus.pendente:
        backgroundColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange;
        break;
      case ReporteStatus.enviado:
        backgroundColor = Colors.yellow.withValues(alpha: 0.2);
        textColor = Colors.yellow[800]!;
        break;
      case ReporteStatus.emAnalise:
        backgroundColor = Colors.blue.withValues(alpha: 0.2);
        textColor = Colors.blue;
        break;
      case ReporteStatus.rejeitado:
        backgroundColor = Colors.red.withValues(alpha: 0.2);
        textColor = Colors.red;
        break;
      case ReporteStatus.resolvido:
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusToString(status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusToString(ReporteStatus status) {
    switch (status) {
      case ReporteStatus.pendente:
        return 'Pendente';
      case ReporteStatus.enviado:
        return 'Enviado';
      case ReporteStatus.emAnalise:
        return 'Em Análise';
      case ReporteStatus.rejeitado:
        return 'Rejeitado';
      case ReporteStatus.resolvido:
        return 'Resolvido';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ontem ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /*void _exibirDetalhesModal(BuildContext context, ReporteBase reporte) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Para manter o estilo da página de detalhes
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9, // Define que o modal ocupará 90% da tela
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: DetalheReportePagina(reporte: reporte),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppCores.neonBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  void _abrirDetalhesReporte(BuildContext context, ReporteBase reporte) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheReportePagina(reporte: reporte),
      ),
    );
  }
}
