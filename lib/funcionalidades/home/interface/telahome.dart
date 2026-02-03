import 'package:flutter/material.dart';
import '../../../core/utilitarios/funcoesauxiliares.dart';
import '../../../core/constantes/cores.dart';
import '../dados/dadoshome.dart';
import 'componentes/listanotificacoes.dart';
import 'componentes/listafuncionalidades.dart';
import 'componentes/cabecalhohome.dart';
import 'componentes/informacoesconta.dart'; // Importe o novo arquivo

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          const InformacoesConta(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppCores.deepBlue,
        border: Border(
          top: BorderSide(color: AppCores.neonBlue.withValues(alpha: 0.2)),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppCores.neonBlue,
        unselectedItemColor: Colors.white.withValues(alpha: 0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            activeIcon: Icon(Icons.insert_chart),
            label: 'Consumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
