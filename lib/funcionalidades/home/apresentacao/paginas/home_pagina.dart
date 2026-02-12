import 'package:flutter/material.dart';

// Imports do Core
import '../../../../core/constantes/cores.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';

// Import de Domínio
import '../../../perfil/dominio/entidades/usuario.dart';
import '../../../home/dados/fonte_dados/home_local_datasource.dart';

// Imports da própria funcionalidade Home
import '../componentes/cabecalho_home_widget.dart';
import '../componentes/lista_funcionalidades_widget.dart';
import '../componentes/lista_notificacoes_widget.dart';
import '../componentes/resumo_conta_widget.dart';
import '../../../home/apresentacao/paginas/historico_reportes_pagina.dart';
import '../../../ajustes/apresentacao/paginas/ajustes_pagina.dart';

class HomePagina extends StatefulWidget {
  const HomePagina({super.key});

  @override
  State<HomePagina> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePagina> {
  int _selectedIndex = 0;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  late Usuario usuarioLogado;

  @override
  void initState() {
    super.initState();
    usuarioLogado = DadosHome.usuario;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showSearchBar = false; // Fecha a busca ao mudar de aba
    });
  }

  // Renderiza o conteúdo da aba selecionada
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return HistoricoReportesPagina(onBackToHome: () => _onItemTapped(0));
      case 2:
        return AjustesPagina(onBackToHome: () => _onItemTapped(0));
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CabecalhoHome(user: DadosHome.userData),
          const SizedBox(height: 20),
          ListaFuncionalidades(searchController: _searchController),
          const SizedBox(height: 20),
          const NotificacoesLista(compacta: true),
          const SizedBox(height: 20),
          const ResumoContaWidget(),
        ],
      ),
    );
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray,
      // Lógica de AppBar Dinâmica
      appBar: _selectedIndex == 0
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
          : null, // O Histórico (index 1) já possui sua própria AppBar no código enviado
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppCores.deepBlue,
        border: Border(
          top: BorderSide(color: AppCores.neonBlue.withValues(alpha: 0.2)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppCores.neonBlue,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_showSearchBar) return [];
    return [
      IconButton(
        icon: const Icon(Icons.search_outlined),
        onPressed: _toggleSearchBar,
      ),
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () => NotificacoesLista.exibirTodasNotificacoes(context),
      ),
      IconButton(
        icon: const Icon(Icons.logout_outlined),
        onPressed: () => FuncoesAuxiliares.exibirLogout(context),
      ),
    ];
  }
}
