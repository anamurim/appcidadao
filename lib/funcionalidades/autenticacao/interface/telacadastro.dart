import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/linhaconexao.dart';
import '../../../../core/widgets/particulas.dart';
import '/../../../funcionalidades/home/interface/componentes/listanotificacoes.dart';
import '../../../../core/utilitarios/funcoesauxiliares.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  // A variável agora será usada para mudar o estado da UI
  bool _isLoading = false;

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(
        () => _isLoading = true,
      ); // Uso da variável (remove o aviso de unused)

      // Simulação de cadastro (API)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
            icon: const Icon(Icons.notifications_none),
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
      body: Stack(
        children: [
          const ParticulasWidget(),
          CustomPaint(
            painter: ConnectionLinesPainter(
              color: AppCores.electricBlue.withValues(alpha: 0.1),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Faça seu cadastro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome Completo',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppCores.neonBlue),
        filled: true,
        fillColor: AppCores.lightGray.withValues(alpha: 0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.neonBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // Se estiver carregando, o botão fica desativado (null)
        onPressed: _isLoading ? null : _handleSignup,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'FINALIZAR CADASTRO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
