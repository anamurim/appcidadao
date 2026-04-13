import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/modelos/reporte_base.dart';
import '../../../../core/modelos/reporte_status.dart';
import '../../controladores/reporte_controller.dart';

/// Página com mapa interativo mostrando os reportes urbanos.
///
/// Utiliza OpenStreetMap via flutter_map (sem necessidade de API key).
/// Cada reporte é representado por um marcador clicável no mapa.
class MapaReportesPagina extends StatefulWidget {
  const MapaReportesPagina({super.key});

  @override
  State<MapaReportesPagina> createState() => _MapaReportesPaginaState();
}

class _MapaReportesPaginaState extends State<MapaReportesPagina> {
  final MapController _mapController = MapController();

  // Coordenadas padrão: São Luís, MA (sede da Equatorial)
  static const _defaultCenter = LatLng(-2.5297, -44.2825);
  static const _defaultZoom = 13.0;

  @override
  void initState() {
    super.initState();
    // Carrega reportes ao abrir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteController>().carregarReportes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Reportes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(_defaultCenter, _defaultZoom);
            },
          ),
        ],
      ),
      body: Consumer<ReporteController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppCores.neonBlue),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _defaultCenter,
                  initialZoom: _defaultZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.equatorial.appcidadao',
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(controller.reportes),
                  ),
                ],
              ),

              // ── Legenda ──
              Positioned(
                bottom: 16,
                left: 16,
                child: _buildLegenda(),
              ),

              // ── Contador total ──
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppCores.deepBlue.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.totalReportes} reportes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Marker> _buildMarkers(List<ReporteBase> reportes) {
    // Para demonstração, distribui os markers ao redor do centro
    // Em produção, usaria coordenadas reais do reporte
    return List.generate(reportes.length, (index) {
      final reporte = reportes[index];
      final offset = index * 0.003;

      return Marker(
        point: LatLng(
          _defaultCenter.latitude + offset * (index.isEven ? 1 : -1),
          _defaultCenter.longitude + offset * (index.isOdd ? 1 : -1),
        ),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _mostrarDetalhes(reporte),
          child: Container(
            decoration: BoxDecoration(
              color: _corDoStatus(reporte.status),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.report_problem,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    });
  }

  Color _corDoStatus(ReporteStatus status) {
    switch (status) {
      case ReporteStatus.pendente:
        return Colors.orange;
      case ReporteStatus.enviado:
        return AppCores.electricBlue;
      case ReporteStatus.emAnalise:
        return Colors.amber;
      case ReporteStatus.rejeitado:
        return Colors.red;
      case ReporteStatus.resolvido:
        return AppCores.accentGreen;
    }
  }

  void _mostrarDetalhes(ReporteBase reporte) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              reporte.tipoReporte.toUpperCase(),
              style: TextStyle(
                color: AppCores.neonBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _detalheRow(Icons.location_on, reporte.endereco),
            _detalheRow(Icons.info, reporte.descricao),
            _detalheRow(
              Icons.check_circle,
              'Status: ${reporte.status.rotulo}',
            ),
            _detalheRow(
              Icons.calendar_today,
              'Criado em: ${_formatarData(reporte.dataCriacao)}',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppCores.electricBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'FECHAR',
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
    );
  }

  Widget _detalheRow(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppCores.neonBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegenda() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .scaffoldBackgroundColor
            .withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Legenda',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          _legendaItem(Colors.orange, 'Pendente'),
          _legendaItem(AppCores.electricBlue, 'Enviado'),
          _legendaItem(Colors.amber, 'Em Análise'),
          _legendaItem(AppCores.accentGreen, 'Resolvido'),
        ],
      ),
    );
  }

  Widget _legendaItem(Color cor, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}
