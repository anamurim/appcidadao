import 'package:flutter/material.dart';
import '../dados/dadoshome.dart';
import '../../../core/constantes/cores.dart';
import 'componentes/cabecalhohome.dart';
//import 'componentes/cardservico.dart';
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
            ? _buildSearchField()
            : const Text(
                'APP CIDADÃO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

        backgroundColor: AppCores.deepBlue,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () => setState(() => _showSearchBar = !_showSearchBar),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificacoesPanel(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
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
          //const ListaNotificacoes(),
          const SizedBox(height: 24),

          // Informações da conta
          //_buildAccountInfo(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Buscar serviço...',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppCores.lightGray,
        title: const Text('Sair do App', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: AppCores.neonBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppCores.neonBlue),
            child: const Text('SAIR'),
          ),
        ],
      ),
    );
  }
}
