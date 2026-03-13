import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/reporte_status.dart';
import '../../../../core/widgets/media_preview_grid.dart';
import '../../controladores/reporte_controller.dart';
import '../../dados/modelos/reporte_interferencia.dart';

/// Página de histórico de reportes com filtros e busca.
///
/// Utiliza o [ReporteController] via Provider em vez de acessar
/// o repositório diretamente. Oferece:
/// - Barra de busca por texto (endereço, descrição)
/// - Filtros por tipo de reporte (chips)
/// - Filtros por status (chips)
=======
import '../../../../core/constantes/cores.dart';
import '../../../perfil/dados/repositorios/reporte_repositorio_local.dart';
import '../../../reportes/dominio/entidades/reporte_base.dart';
import '../../dados/modelos/reporte_interferencia.dart';

>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
class HistoricoReportesPagina extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const HistoricoReportesPagina({super.key, this.onBackToHome});

  @override
  State<HistoricoReportesPagina> createState() =>
      _HistoricoReportesPaginaState();
}

class _HistoricoReportesPaginaState extends State<HistoricoReportesPagina> {
<<<<<<< HEAD
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
      resultado =
          resultado.where((r) => r.tipoReporte == _filtroTipo).toList();
    }

    // Filtro por status
    if (_filtroStatus != null) {
      resultado =
          resultado.where((r) => r.status == _filtroStatus).toList();
    }

    return resultado;
  }
=======
  final _repositorio = ReporteRepositorioLocal();
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
=======
      //backgroundColor: AppCores.techGray,
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
      appBar: AppBar(
        title: const Text('Histórico de Reportes'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
<<<<<<< HEAD
          onPressed:
              widget.onBackToHome ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ReporteController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
=======
          onPressed: widget.onBackToHome ?? () => Navigator.of(context).pop(),
        ),
        //backgroundColor: AppCores.deepBlue,
      ),
      body: FutureBuilder<List<ReporteBase>>(
        // Utiliza o método exato do seu repositório
        future: _repositorio.listarReportes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
            return const Center(
              child: CircularProgressIndicator(color: AppCores.neonBlue),
            );
          }

<<<<<<< HEAD
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
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reportesFiltrados.length,
                        itemBuilder: (context, index) {
                          return _buildReporteCard(
                              reportesFiltrados[index]);
                        },
                      ),
              ),
            ],
=======
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
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
          );
        },
      ),
    );
  }

<<<<<<< HEAD
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
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.5),
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
    final tiposUnicos =
        todosReportes.map((r) => r.tipoReporte).toSet().toList()..sort();

    if (tiposUnicos.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildChip(
              label: 'Todos',
              selecionado: _filtroTipo == null,
              onTap: () => setState(() => _filtroTipo = null),
            ),
            ...tiposUnicos.map((tipo) => _buildChip(
                  label: _formatarTipo(tipo),
                  selecionado: _filtroTipo == tipo,
                  onTap: () => setState(
                    () =>
                        _filtroTipo = _filtroTipo == tipo ? null : tipo,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltrosStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: ReporteStatus.values.map((status) {
            return _buildChip(
              label: status.rotulo,
              selecionado: _filtroStatus == status,
              cor: _corDoStatus(status),
              onTap: () => setState(
                () => _filtroStatus =
                    _filtroStatus == status ? null : status,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selecionado,
    Color? cor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: selecionado ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: selecionado
              ? (cor ?? AppCores.electricBlue)
              : AppCores.lightGray.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

=======
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 64,
<<<<<<< HEAD
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty ||
                    _filtroTipo != null ||
                    _filtroStatus != null
                ? 'Nenhum reporte encontrado com esses filtros.'
                : 'Nenhum reporte enviado até o momento.',
=======
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum reporte enviado até o momento.',
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
<<<<<<< HEAD
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty ||
              _filtroTipo != null ||
              _filtroStatus != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _filtroTipo = null;
                  _filtroStatus = null;
                });
              },
              child: const Text(
                'Limpar filtros',
                style: TextStyle(color: AppCores.neonBlue),
              ),
            ),
          ],
=======
          ),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
        ],
      ),
    );
  }

  Widget _buildReporteCard(ReporteBase reporte) {
<<<<<<< HEAD
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _corDoStatus(reporte.status).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _iconeDoTipo(reporte.tipoReporte),
            color: _corDoStatus(reporte.status),
          ),
        ),
        title: Text(
          _formatarTipo(reporte.tipoReporte),
=======
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
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
<<<<<<< HEAD
              reporte.endereco,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _corDoStatus(reporte.status)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reporte.status.rotulo,
                    style: TextStyle(
                      color: _corDoStatus(reporte.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatarData(reporte.dataCriacao),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ],
=======
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
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface,
        ),
<<<<<<< HEAD
        onTap: () => _exibirDetalhes(reporte),
=======
        onTap: () => _exibirDetalhes(reporte, titulo),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
      ),
    );
  }

<<<<<<< HEAD
  void _exibirDetalhes(ReporteBase reporte) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
=======
  void _exibirDetalhes(ReporteBase reporte, String titulo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppCores.deepBlue,
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
<<<<<<< HEAD
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
=======
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
<<<<<<< HEAD
                _formatarTipo(reporte.tipoReporte),
=======
                titulo,
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
                style: const TextStyle(
                  color: AppCores.neonBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

<<<<<<< HEAD
              _itemDetalhe('Endereço', reporte.endereco),
              _itemDetalhe(
                'Referência',
                reporte.pontoReferencia ?? 'Não informado',
              ),
              _itemDetalhe('Descrição', reporte.descricao),

              // Campos específicos de interferência
              if (reporte is ReporteInterferencia) ...[
                _itemDetalhe(
                    'Tipo', reporte.tipoInterferencia),
=======
              if (reporte is ReporteInterferencia) ...[
                _itemDetalhe('Endereço', reporte.endereco),
                _itemDetalhe(
                  'Referência',
                  reporte.pontoReferencia ?? 'Não informado',
                ),
                _itemDetalhe('Descrição', reporte.descricao),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
                if (reporte.nomeContato != null)
                  _itemDetalhe('Contato', reporte.nomeContato!),
              ],

              _itemDetalhe(
<<<<<<< HEAD
                'Status',
                reporte.status.rotulo,
              ),
              _itemDetalhe(
                'Data',
                _formatarData(reporte.dataCriacao),
              ),

              // Galeria de mídias (com zoom/fullscreen)
              if (reporte.midias.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Mídias anexadas',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                MediaPreviewGrid(
                  midias: reporte.midias,
                  editavel: false,
                ),
              ],

=======
                'Status do Protocolo',
                reporte.status.name.toUpperCase(),
              ),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
<<<<<<< HEAD
      padding: const EdgeInsets.only(bottom: 16),
=======
      padding: const EdgeInsets.only(bottom: 20),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
<<<<<<< HEAD
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
=======
            style: const TextStyle(
              color: Colors.white54,
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
<<<<<<< HEAD
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
=======
            style: const TextStyle(color: Colors.white, fontSize: 16),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  // ── Helpers ──

  IconData _iconeDoTipo(String tipo) {
    switch (tipo) {
      case 'iluminacao':
        return Icons.lightbulb;
      case 'semaforo':
        return Icons.traffic;
      case 'sinalizacao':
        return Icons.signpost;
      case 'estacionamento':
        return Icons.local_parking;
      case 'veiculo':
        return Icons.directions_car;
      case 'interferencia':
        return Icons.warning;
      default:
        return Icons.assignment_outlined;
    }
  }

  Color _corDoStatus(ReporteStatus status) {
    switch (status) {
      case ReporteStatus.pendente:
        return Colors.orange;
      case ReporteStatus.enviado:
        return AppCores.electricBlue;
      case ReporteStatus.emAnalise:
        return Colors.amber;
      case ReporteStatus.resolvido:
        return AppCores.accentGreen;
    }
  }

  String _formatarTipo(String tipo) {
    switch (tipo) {
      case 'iluminacao':
        return 'Iluminação Pública';
      case 'semaforo':
        return 'Semáforo';
      case 'sinalizacao':
        return 'Sinalização';
      case 'estacionamento':
        return 'Estacionamento Irregular';
      case 'veiculo':
        return 'Veículo Quebrado';
      case 'interferencia':
        return 'Interferência';
      default:
        return tipo;
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
=======
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
}
