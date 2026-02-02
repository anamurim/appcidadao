import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/home/dados/dadoshome.dart';
import 'cardservico.dart';

class ListaFuncionalidades extends StatelessWidget {
  const ListaFuncionalidades({super.key});

  @override
  Widget build(BuildContext context) {
    // Busca a lista de funcionalidades definida no seu dadoshome.dart
    final funcionalidades = DadosHome.getfuncionalidades;
    final problemasurbanos = DadosHome.getproblemasurbanos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: Text(
            'Funcionalidades principais',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        // GridView para organizar os cards em 2 colunas
        GridView.builder(
          shrinkWrap:
              true, // Importante para funcionar dentro do SingleChildScrollView
          physics:
              const NeverScrollableScrollPhysics(), // Evita conflito de rolagem
          padding: const EdgeInsets.symmetric(horizontal: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 cards por linha
            crossAxisSpacing: 12, // Espaçamento horizontal
            mainAxisSpacing: 12, // Espaçamento vertical
            childAspectRatio: 0.9, // Proporção do card
          ),
          itemCount: funcionalidades.length,
          itemBuilder: (context, index) {
            return CardServico(dados: funcionalidades[index]);
          },
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: Text(
            'Problemas Urbanos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: problemasurbanos.length,
          itemBuilder: (context, index) {
            return CardServico(dados: problemasurbanos[index]);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
