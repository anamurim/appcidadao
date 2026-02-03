import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/home/dados/dadoshome.dart';
import '../../../../core/constantes/cores.dart';

class ListaFuncionalidades extends StatefulWidget {
  const ListaFuncionalidades({super.key});

  @override
  State<ListaFuncionalidades> createState() => _ListaFuncionalidadesState();
}

class _ListaFuncionalidadesState extends State<ListaFuncionalidades> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get _filteredFeatures {
    // 1. Combinamos as duas listas da classe DadosHome em uma só
    final todasAsFuncionalidades = [
      ...DadosHome.getfuncionalidades,
      //...DadosHome.getproblemasurbanos,
    ];

    if (_searchController.text.isEmpty) {
      return todasAsFuncionalidades;
    }

    return todasAsFuncionalidades
        .where(
          (f) => f['title'].toString().toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFeaturesGrid();
  }

  Widget _buildFeaturesGrid() {
    final problemasUrbanos = _filteredFeatures
        .where((feature) => feature['category'] == 'problemas_urbanos')
        .toList();
    final listafuncionalidades = _filteredFeatures
        .where((feature) => feature['category'] != 'problemas_urbanos')
        .toList();

    return SingleChildScrollView(
      //Permite scroll
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Resultados da busca: ${_filteredFeatures.length} encontrados',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ),

          if (listafuncionalidades.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Funcionalidades Principais',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
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
                  itemBuilder: (context, index) {
                    final feature = listafuncionalidades[index];
                    return _buildFeatureCard(feature);
                  },
                ),
              ],
            ),

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
              itemBuilder: (context, index) {
                final feature = problemasUrbanos[index];
                return _buildFeatureCard(feature);
              },
            ),
          ],
        ],
      ),
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
        borderRadius: BorderRadius.circular(15),
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
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (feature['color'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    feature['icon'],
                    color: feature['color'],
                    size: 32,
                  ),
                ),
              ),
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
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: feature['color'],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'FECHAR',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
