import '../../../ajustes/apresentacao/paginas/ajustes_pagina.dart';
import 'package:flutter/material.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';
import '../../../../core/constantes/cores.dart';
import '../../dados/fonte_dados/home_local_datasource.dart';
import '../../apresentacao/componentes/lista_funcionalidades_widget.dart';
import '../../apresentacao/componentes/lista_notificacoes_widget.dart';
import '../../apresentacao/componentes/cabecalho_home_widget.dart';
import '../../apresentacao/componentes/resumo_conta_widget.dart';
import '../../apresentacao/paginas/historico_reportes_pagina.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  // Função para mudar de aba via código
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showSearchBar = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define as páginas aqui dentro do build para garantir que a função de callback esteja atualizada
    final List<Widget> paginas = [
      _buildHomePageContent(), // Index 0
      HistoricoReportesPagina(
        onBackToHome: () => _onItemTapped(0), // Leva para o Início
      ), // Index 1 - Substituído o Center pelo Histórico real
      AjustesPagina(onBackToHome: () => _onItemTapped(0)), // Index 2
    ];

    return Scaffold(
      backgroundColor: AppCores.techGray,
      // Remove a AppBar apenas no index 2 (Configurações)
      appBar: _selectedIndex == 1
          ? null
          : _selectedIndex == 2
          ? AppBar(
              title: _showSearchBar
                  ? FuncoesAuxiliares.construirCampoBusca(
                      controller: _searchController,
                      onClear: _toggleSearchBar,
                      onChanged: (value) => setState(() {}),
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
              actions: _buildAppBarActions(),
            )
          : AppBar(
              title: const Text('Histórico'),
              backgroundColor: AppCores.deepBlue,
              elevation: 0,
            ),
      body: IndexedStack(index: _selectedIndex, children: paginas),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomePageContent() {
    final user = DadosHome.userData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          CabecalhoHome(user: user),
          const SizedBox(height: 24),
          ListaFuncionalidades(searchController: _searchController),
          const SizedBox(height: 24),
          const NotificacoesLista(),
          const SizedBox(height: 24),
          const InformacoesConta(),
          const SizedBox(height: 24),
        ],
      ),
    );
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_showSearchBar) {
      return [];
    }

    return [
      IconButton(
        icon: Icon(Icons.search_outlined, color: Colors.white),
        onPressed: _toggleSearchBar,
      ),
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () => NotificacoesLista.exibirTodasNotificacoes(context),
      ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () => FuncoesAuxiliares.exibirLogout(context),
      ),
    ];
  }
}
