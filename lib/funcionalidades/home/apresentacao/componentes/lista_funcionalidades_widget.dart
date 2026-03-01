//import 'package:appcidadao/funcionalidades/ajustes/apresentacao/paginas/ajustes_pagina.dart';
import 'package:appcidadao/funcionalidades/home/apresentacao/paginas/suporte_energia_pagina.dart';
import 'package:flutter/material.dart';
import '../../dados/fonte_dados/home_local_datasource.dart';
import '../../../../core/constantes/cores.dart';
import '../../../perfil/tela_perfil.dart';
import '../../../home/apresentacao/paginas/consumo_pagina.dart';
import '../../../home/apresentacao/paginas/pagamentos_pagina.dart';
import '../../../home/apresentacao/paginas/falta_energia_pagina.dart';
import '../../../home/apresentacao/paginas/economia_pagina.dart';
//import '../../../home/apresentacao/paginas/suporte_energia_pagina.dart';
import '../paginas/interferencia_pagina.dart';
//import '../../../ajustes/apresentacao/paginas/ajustes_pagina.dart';
import '../paginas/reporte_semaforo_pagina.dart';
import '../paginas/veiculos_quebrado_pagina.dart';
import '../paginas/estacionamento_irregular_pagina.dart';
import '../paginas/reporte_sinalizacao_pagina.dart';
import '../paginas/reporte_iluminacao_pagina.dart';

class ListaFuncionalidades extends StatefulWidget {
  final TextEditingController searchController;

  const ListaFuncionalidades({super.key, required this.searchController});

  @override
  State<ListaFuncionalidades> createState() => _ListaFuncionalidadesState();
}

class _ListaFuncionalidadesState extends State<ListaFuncionalidades> {
  List<Map<String, dynamic>> get _filteredFeatures {
    final featuresServicos = DadosHome.getServicosEnergia;
    if (widget.searchController.text.isEmpty) {
      return featuresServicos;
    }

    final features = DadosHome.getProblemasUrbanos;
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
    Widget? paginaDestino;

    // Mapeamento de títulos para telas
    switch (feature['title']) {
      case 'Minha Conta':
        paginaDestino = const TelaPerfil();
        break;
      case 'Consumo':
        paginaDestino = const ConsumoEnergiaPagina();
        break;
      case 'Pagamentos':
        paginaDestino = const HistoricoPagamentosPagina();
        break;
      case 'Suporte':
        paginaDestino = const SuporteEnergiaPagina();
        break;
      case 'Falta de Energia':
        paginaDestino = const FaltaEnergiaPagina();
        break;
      case 'Economia':
        paginaDestino = const DicasEconomiaPagina();
        break;
      case 'Interferência na Via':
        paginaDestino = const TelaReportarInterferencia();
        break;
      case 'Semáforo':
        paginaDestino = const TelaReportarSemaforo();
        break;
      case 'Veículo Quebrado':
        paginaDestino = const TelaVeiculoQuebrado();
        break;
      case 'Estacionamento Irregular':
        paginaDestino = const TelaEstacionamentoIrregular();
        break;
      case 'Sinalização':
        paginaDestino = const TelaReporteSinalizacao();
        break;
      case 'Iluminação Pública':
        paginaDestino = const TelaReporteIluminacao();
        break;
      default:
        paginaDestino = null;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => paginaDestino!),
    );
  }

  /* // FUNÇÃO DE NAVEGAÇÃO CENTRALIZADA - VERSÃO USANDO ROTAS
  void _executarChamadaFuncionalidade(Map<String, dynamic> feature) {
    String? rota;

    // Mapeamos o título do DadosHome para a String da rota na main.dart
    switch (feature['title']) {
      case 'Interferência na Via':
        rota = '/interferencia';
        break;
      case 'Pagamentos':
        rota = '/pagamentos';
        break;
      default:
        rota = null;
    }

    if (rota != null) {
      // Navegação usando o nome da rota registrado na main.dart
      Navigator.pushNamed(context, rota);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A tela de "${feature['title']}" está em desenvolvimento.'),
          backgroundColor: Colors.blueGrey,
        ),
      );
    }
  } */

  @override
  Widget build(BuildContext context) {
    return _buildFeaturesGrid();
  }

  Widget _buildFeaturesGrid() {
    final filtered = _filteredFeatures;
    final listafuncionalidades = filtered
        .where((feature) => feature['category'] == 'funcionalidades_principais')
        .toList();
    final problemasUrbanos = filtered
        .where((feature) => feature['category'] != 'problemas_urbanos')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (listafuncionalidades.isNotEmpty) ...[
          _buildSecaoTitulo('Serviços de Energia'),
          const SizedBox(height: 16),
          _buildGrid(DadosHome.getServicosEnergia),
        ],
        if (problemasUrbanos.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSecaoTitulo('Problemas Urbanos'),
          const SizedBox(height: 16),
          _buildGrid(DadosHome.getProblemasUrbanos),
        ],
      ],
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature['description'] ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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
            const SizedBox(height: 8), // Pequeno espaçamento entre os botões
            // BOTÃO CANCELAR
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Navigator.pop(context); // Apenas fecha o modal
              },
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface, // Cor mais discreta
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
