import 'package:flutter/material.dart';
import 'package:appcidadao/funcionalidades/home/dados/dadoshome.dart';
import 'cardservico.dart';

class ListaFuncionalidades extends StatelessWidget {
  const ListaFuncionalidades({super.key});

  @override
  Widget build(BuildContext context) {
    // Busca a lista de funcionalidades definida no seu dadoshome.dart
    final funcionalidades = DadosHome.getfuncionalidades;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(
            'FUNCIONALIDADES PRINCIPAIS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 2 cards por linha
            crossAxisSpacing: 12, // Espaçamento horizontal
            mainAxisSpacing: 12, // Espaçamento vertical
            childAspectRatio: 0.9, // Proporção do card
          ),
          itemCount: funcionalidades.length,
          itemBuilder: (context, index) {
            return CardServico(dados: funcionalidades[index]);
          },
        ),
      ],
    );
  }
}
