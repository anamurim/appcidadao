import 'package:flutter/material.dart';
import '../../dados/fonte_dados/home_local_datasource.dart';
import '../../../../core/constantes/cores.dart';
// Importe a sua página de interferência
import '../paginas/interferencia_pagina.dart';

class ListaFuncionalidades extends StatefulWidget {
  final TextEditingController searchController;

  const ListaFuncionalidades({super.key, required this.searchController});

  @override
  State<ListaFuncionalidades> createState() => _ListaFuncionalidadesState();
}

class _ListaFuncionalidadesState extends State<ListaFuncionalidades> {
  List<Map<String, dynamic>> get _filteredFeatures {
    final features = DadosHome.getfuncionalidades;
    if (widget.searchController.text.isEmpty) {
      return features;
    }

    final query = widget.searchController.text.toLowerCase();
    return features.where((feature) {
      return feature['title'].toLowerCase().contains(query) ||
          (feature['category']?.toString().toLowerCase() ?? '').contains(query);
    }).toList();
  }

  // FUNÇÃO DE NAVEGAÇÃO CENTRALIZADA
  void _executarChamadaFuncionalidade(Map<String, dynamic> feature) {
    Widget? destino;

    // Mapeamento de títulos para telas
    switch (feature['title']) {
      case 'Interferência na Via':
        destino = const TelaReportarInterferencia();
        break;
      // Você pode adicionar novos cases aqui conforme criar as outras telas:
      // case 'Sinalização':
      //   destino = const TelaSinalizacao();
      //   break;
      default:
        destino = null;
    }

    if (destino != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destino!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Funcionalidade ${feature['title']} em desenvolvimento',
          ),
          backgroundColor: AppCores.electricBlue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildFeaturesGrid();
  }

  Widget _buildFeaturesGrid() {
    final filtered = _filteredFeatures;
    final problemasUrbanos = filtered
        .where((feature) => feature['category'] == 'problemas_urbanos')
        .toList();
    final listafuncionalidades = filtered
        .where((feature) => feature['category'] != 'problemas_urbanos')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (listafuncionalidades.isNotEmpty) ...[
          _buildSecaoTitulo('Funcionalidades Principais'),
          const SizedBox(height: 16),
          _buildGrid(listafuncionalidades),
        ],
        if (problemasUrbanos.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSecaoTitulo('Problemas Urbanos'),
          const SizedBox(height: 16),
          _buildGrid(problemasUrbanos),
        ],
      ],
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> itens) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: itens.length,
      itemBuilder: (context, index) => _buildFeatureCard(itens[index]),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature['icon'], color: feature['color'], size: 28),
              const SizedBox(height: 8),
              Text(
                feature['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
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
                fontWeight: FontWeight.bold,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Fecha o modal
                _executarChamadaFuncionalidade(feature); // Chama a tela
              },
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
