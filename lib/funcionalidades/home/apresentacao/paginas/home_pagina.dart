import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/debug/firestore_debug_widget.dart';
import '../../controladores/usuario_controller.dart';
import '../../controladores/reporte_controller.dart';
import '../../apresentacao/componentes/lista_funcionalidades_widget.dart';
import '../../apresentacao/componentes/lista_notificacoes_widget.dart';
import '../../apresentacao/componentes/cabecalho_home_widget.dart';
import '../../apresentacao/componentes/resumo_conta_widget.dart';
import '../../../ajustes/apresentacao/paginas/ajustes_pagina.dart';
import 'detalhe_reporte_pagina.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Busca os dados reais assim que a tela é montada
      context.read<UsuarioController>().carregarUsuario();
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
      //backgroundColor: AppCores.techGray,
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
                      _selectedIndex == 0
                          ? 'APP CIDADÃO'
                          : 'Histórico de Reportes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              //backgroundColor: AppCores.deepBlue,
              actions: _selectedIndex == 0 ? _buildAppBarActions() : null,
            ),
      body: IndexedStack(index: _selectedIndex, children: paginas),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Debug',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => FirestoreDebugWidget(),
        ),
        child: const Icon(Icons.bug_report),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const CabecalhoHome(),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum reporte enviado ainda',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
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
      'Conta': Icons.account_balance_wallet,
      'Consumo': Icons.show_chart,
      'Pagamentos': Icons.payment,
      'Suporte': Icons.support_agent,
      'Energia': Icons.power_off,
      'Economia': Icons.eco,
      'Interferencia': Icons.traffic,
      'Semaforo': Icons.traffic_outlined,
      'Veiculo': Icons.car_repair,
      'Estacionamento': Icons.local_parking,
      'Sinalizacao': Icons.signpost,
      'Iluminacao': Icons.lightbulb_outline,
    };

    final icon = tipoIcones[reporte.tipoReporte] ?? Icons.report;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          reporte.endereco,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Status: ${reporte.status.rotulo}",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        // Ação de clicar para ver detalhes (inspirado no listalivro.dart)
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheReportePagina(reporte: reporte),
            ),
          );
        },
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
            label: 'Configurações',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_showSearchBar) return [];
    return [
      IconButton(
        icon: const Icon(Icons.search_outlined, color: Colors.white),
        onPressed: _toggleSearchBar,
      ),
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white),
        onPressed: () => NotificacoesLista.exibirTodasNotificacoes(context),
      ),
      IconButton(
        icon: const Icon(Icons.logout_outlined, color: Colors.white),
        onPressed: () => FuncoesAuxiliares.exibirLogout(context),
      ),
    ];
  }
}
