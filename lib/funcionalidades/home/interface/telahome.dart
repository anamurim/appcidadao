import 'package:flutter/material.dart';
import '../dados/dadoshome.dart';
import '../../../core/constantes/cores.dart';
import 'componentes/listanotificacoes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Variável de índice conectada ao BottomNavigationBar
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  //Lista de páginas para alternar na Home
  final List<Widget> _pages = [
    const HomeContent(), // Conteúdo principal que criamos abaixo
    const Center(
      child: Text('Consumo', style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text('Configurações', style: TextStyle(color: Colors.white)),
    ),
  ];

  // 3. Função de troca de aba conectada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 4. Função de Logout conectada
  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
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
                  //fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: AppCores.deepBlue,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () => setState(() => _showSearchBar = !_showSearchBar),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificacoesPanel(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Conectando a função de logout
          ),
        ],
      ),
      // Exibindo a página baseada no índice selecionado
      body: _selectedIndex == 0 ? const HomeContent() : _pages[_selectedIndex],

      // Conectando o BottomNavigationBar para usar o _selectedIndex e _onItemTapped
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppCores.deepBlue,
        selectedItemColor: AppCores.neonBlue,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Consumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }

  // 5. Função de busca agora referenciada no AppBar
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
}

// Widget auxiliar para organizar o conteúdo da aba "Início"
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DadosHome.userData;
    final funcionalidades = DadosHome.getfeatures;

    return Column(
      children: [
        _buildUserHeader(user),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: funcionalidades.length,
            itemBuilder: (context, index) {
              final item = funcionalidades[index];
              return _buildFeatureCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> user) {
    final user = DadosHome.userData;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppCores.deepBlue, AppCores.electricBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppCores.electricBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppCores.neonBlue, width: 2),
            ),
            child: Center(
              child: Icon(Icons.person, size: 40, color: AppCores.deepBlue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${user['name']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppCores.neonBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppCores.neonBlue, width: 1),
                  ),
                  child: Text(
                    'Conta: ${user['account']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      decoration: BoxDecoration(
        color: AppCores.lightGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (feature['color'] as Color).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(feature['icon'], color: feature['color'], size: 40),
          const SizedBox(height: 10),
          Text(
            feature['title'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
