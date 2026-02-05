import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/home/dados/dadoshome.dart';
import '../../../../core/constantes/cores.dart';

class ListaFuncionalidades extends StatefulWidget {
  final TextEditingController searchController;

  const ListaFuncionalidades({super.key, required this.searchController});

  @override
  State<ListaFuncionalidades> createState() => _ListaFuncionalidadesState();
}

class _ListaFuncionalidadesState extends State<ListaFuncionalidades> {
  // Implementação do snippet de filtragem
  List<Map<String, dynamic>> get _filteredFeatures {
    final features = DadosHome.getfuncionalidades;
    if (widget.searchController.text.isEmpty) {
      return features;
    }

    final query = widget.searchController.text.toLowerCase();
    return features.where((feature) {
      return feature['title'].toLowerCase().contains(query) ||
          feature['description'].toLowerCase().contains(query) ||
          (feature['category']?.toString().toLowerCase() ?? '').contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFeaturesGrid();
  }

  Widget _buildFeaturesGrid() {
    final filtered = _filteredFeatures;

    // Separação por categoria solicitada no snippet
    final problemasUrbanos = filtered
        .where((feature) => feature['category'] == 'problemas_urbanos')
        .toList();
    final listafuncionalidades = filtered
        .where((feature) => feature['category'] != 'problemas_urbanos')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicador de resultados da busca
        if (widget.searchController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Resultados da busca: ${filtered.length} encontrados',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),

        // Bloco de Funcionalidades Principais
        if (listafuncionalidades.isNotEmpty) ...[
          const Text(
            'Funcionalidades Principais',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: listafuncionalidades.length,
            itemBuilder: (context, index) =>
                _buildFeatureCard(listafuncionalidades[index]),
          ),
        ],

        // Bloco de Problemas Urbanos
        if (problemasUrbanos.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Problemas Urbanos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 cards por linha
              crossAxisSpacing: 12, // Espaçamento horizontal
              mainAxisSpacing: 12, // Espaçamento vertical
              childAspectRatio: 0.9, // Proporção do card
            ),
            itemCount: problemasUrbanos.length,
            itemBuilder: (context, index) =>
                _buildFeatureCard(problemasUrbanos[index]),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFeatureDetails(feature),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      feature['icon'],
                      color: feature['color'],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureDetails(Map<String, dynamic> feature) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppCores.lightGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(feature['icon'], color: feature['color'], size: 48),
            const SizedBox(height: 16),
            Text(
              feature['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature['description'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: feature['color'],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ACESSAR ${feature['title'].toUpperCase()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
