import 'package:flutter/material.dart';
import '../dados/dadoshome.dart';
import '../../../core/constantes/cores.dart';
import 'componentes/cabecalhohome.dart';
import '../../../core/utilitarios/funcoesauxiliares.dart';
import 'componentes/listanotificacoes.dart';
import 'componentes/listafuncionalidades.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray,
      appBar: AppBar(
        title: _showSearchBar
            ? FuncoesAuxiliares.construirCampoBusca(
                controller: _searchController,
                onClear: () => setState(() => _showSearchBar = false),
              )
            : const Text(
                'APP CIDADÃO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
        backgroundColor: AppCores.deepBlue,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () => setState(() => _showSearchBar = !_showSearchBar),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => NotificacoesLista.exibirTodasNotificacoes(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => FuncoesAuxiliares.exibirLogout(context),
            /*onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Configuracoes(),
              ),*/
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FuncoesAuxiliares.exibirLogout(context),
          ),
        ],
      ),
      body: _buildHomePage(),
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomePage() {
    final user = DadosHome.userData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saudação e informações do usuário
          const SizedBox(height: 24),
          CabecalhoHome(user: user),

          // Cards de funcionalidades e problemas urbanos
          const SizedBox(height: 24),
          const ListaFuncionalidades(),

          // Últimas notificações
          const NotificacoesLista(),
          const SizedBox(height: 24),

          // Informações da conta
          //_buildAccountInfo(),
        ],
      ),
    );
  }
}
