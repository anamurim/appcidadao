import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';
import '../../../../core/constantes/cores.dart';
import '../../controladores/usuario_controller.dart';
import '../../controladores/reporte_controller.dart';
import '../../apresentacao/componentes/lista_funcionalidades_widget.dart';
import '../../apresentacao/componentes/lista_notificacoes_widget.dart';
import '../../apresentacao/componentes/cabecalho_home_widget.dart';
import '../../apresentacao/componentes/resumo_conta_widget.dart';
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

  @override
  void initState() {
    super.initState();
    // Carrega os reportes quando a tela é aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteController>().carregarReportes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Corrigido: Removida a duplicata do método _onItemTapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showSearchBar = false; // Fecha a busca ao mudar de aba
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define as páginas respeitando o que cada uma solicita
    final List<Widget> paginas = [
      _buildHomePageContent(), // Index 0
      _buildHistoricoTab(), // Index 1
      AjustesPagina(onBackToHome: () => _onItemTapped(0)), // Index 2
    ];

    return Scaffold(
      backgroundColor: AppCores.techGray,
      appBar: _selectedIndex == 2
          ? null // Ajustes costuma ter sua própria AppBar ou design
          : AppBar(
              title: _showSearchBar && _selectedIndex == 0
                  ? FuncoesAuxiliares.construirCampoBusca(
                      controller: _searchController,
                      onClear: _toggleSearchBar,
                      onChanged: (value) => setState(() {}),
                    )
                  : Text(
                      _selectedIndex == 0 ? 'APP CIDADÃO' : 'Histórico',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              backgroundColor: AppCores.deepBlue,
              actions: _selectedIndex == 0 ? _buildAppBarActions() : null,
            ),
      body: IndexedStack(index: _selectedIndex, children: paginas),
      bottomNavigationBar:
          _buildBottomNav(), // Nome corrigido para coincidir com o método
    );
  }

  Widget _buildHomePageContent() {
    return Consumer<UsuarioController>(
      builder: (context, usuarioCtrl, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Corrigido: Passando os parâmetros obrigatórios em vez do objeto 'user' inexistente
              CabecalhoHome(
                nome: usuarioCtrl.nome,
                email: usuarioCtrl.email,
                conta: usuarioCtrl.conta,
              ),
              const SizedBox(height: 24),
              ListaFuncionalidades(searchController: _searchController),
              const SizedBox(height: 24),
              const NotificacoesLista(compacta: true),
              const SizedBox(height: 24),
              const ResumoContaWidget(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoricoTab() {
    return Consumer<ReporteController>(
      builder: (context, reporteCtrl, _) {
        if (reporteCtrl.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppCores.neonBlue),
          );
        }

        if (reporteCtrl.reportes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_outlined,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum reporte enviado ainda',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reporteCtrl.reportes.length,
          itemBuilder: (context, index) {
            final reporte = reporteCtrl.reportes[index];
            return _buildReporteCard(reporte);
          },
        );
      },
    );
  }

  Widget _buildReporteCard(dynamic reporte) {
    final Map<String, IconData> tipoIcones = {
      'interferencia': Icons.traffic,
      'semaforo': Icons.traffic_outlined,
      'veiculo': Icons.car_repair,
      'estacionamento': Icons.local_parking,
      'sinalizacao': Icons.signpost,
      'iluminacao': Icons.lightbulb_outline,
    };

    final icon = tipoIcones[reporte.tipoReporte] ?? Icons.report;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppCores.neonBlue, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reporte.endereco,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reporte.status.rotulo,
                  style: const TextStyle(
                    color: AppCores.accentGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
