import '../../../ajustes/apresentacao/paginas/ajustes_pagina.dart';
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
  void initState() {
    super.initState();
    // Carrega os reportes quando a tela é aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteController>().carregarReportes();
    });
  }

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
      _buildHistoricoTab(), // Index 1 — agora com dados reais
      AjustesPagina(
        onBackToHome: () => _onItemTapped(0),
      ), // Passa a função de voltar
    ];

    return Scaffold(
      backgroundColor: AppCores.techGray,
      // Remove a AppBar apenas no index 2 (Configurações)
      appBar: _selectedIndex == 2
          ? null
          : _selectedIndex == 0
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
            ),
      body: IndexedStack(index: _selectedIndex, children: paginas),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
              CabecalhoHome(
                nome: usuarioCtrl.nome,
                email: usuarioCtrl.email,
                conta: usuarioCtrl.conta,
              ),
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
      },
    );
  }

  /// Tab de Histórico — exibe os reportes submetidos pelo usuário.
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
                Text(
                  'Nenhum reporte enviado ainda',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seus reportes aparecerão aqui',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 14,
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

  /// Card individual de um reporte no histórico.
  Widget _buildReporteCard(dynamic reporte) {
    // Mapeamento tipo → ícone e cor
    final Map<String, IconData> tipoIcones = {
      'interferencia': Icons.traffic,
      'semaforo': Icons.traffic_outlined,
      'veiculo': Icons.car_repair,
      'estacionamento': Icons.local_parking,
      'sinalizacao': Icons.signpost,
      'iluminacao': Icons.lightbulb_outline,
    };

    final Map<String, String> tipoLabels = {
      'interferencia': 'Interferência na Via',
      'semaforo': 'Semáforo',
      'veiculo': 'Veículo Quebrado',
      'estacionamento': 'Estacionamento Irregular',
      'sinalizacao': 'Sinalização',
      'iluminacao': 'Iluminação Pública',
    };

    final icon = tipoIcones[reporte.tipoReporte] ?? Icons.report;
    final label = tipoLabels[reporte.tipoReporte] ?? reporte.tipoReporte;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppCores.neonBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppCores.neonBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppCores.neonBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reporte.endereco,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppCores.accentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reporte.status.rotulo,
              style: const TextStyle(
                color: AppCores.accentGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
