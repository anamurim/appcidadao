import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/linha_conexao.dart';
import '../../controladores/autenticacao_controller.dart';
//import '../../../../core/tema/app_tema.dart';
//import '../../../../core/tema/tema_controller.dart';

class TechLoginScreen extends StatefulWidget {
  const TechLoginScreen({super.key});

  @override
  State<TechLoginScreen> createState() => _TechLoginScreenState();
}

class _TechLoginScreenState extends State<TechLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // A GlobalKey deve ser única para um único Form na árvore de widgets
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _handleLogin() async {
    // Valida o formulário antes de prosseguir
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final controller = context.read<AutenticacaoController>();

      final success = await controller.login(
        _emailController.text,
        _passwordController.text,
      );

      // Verifica se o widget ainda está na tela antes de navegar (evita erro de contexto)
      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final msg = controller.errorMessage ?? 'Falha ao realizar login.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  List<Widget> _buildParticles() {
    return [
      Positioned(top: 100, left: 50, child: _buildParticle(4, 0.6)),
      Positioned(top: 200, right: 80, child: _buildParticle(3, 0.8, true)),
      Positioned(top: 300, left: 100, child: _buildParticle(2, 0.4)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppCores.deepBlue,
      body: Stack(
        children: [
          _buildTechBackground(),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 40),
                      _buildLoginForm(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechBackground() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                isDark
                    ? AppCores.deepBlue.withValues(alpha: 0.8)
                    : AppCores.lightGray.withValues(alpha: 0.8),
              ],
              //stops: const [0.1, 0.8],
            ),
          ),
        ),
        ..._buildParticles(),
        CustomPaint(
          painter: ConnectionLinesPainter(
            color: AppCores.lightGray.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildParticle(double size, double opacity, [bool neon = false]) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? AppCores.neonBlue.withValues(alpha: 0.2)
            : AppCores.lightGray.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.35,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppCores.deepBlue, AppCores.electricBlue, AppCores.neonBlue],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    AppCores.neonBlue.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.bolt, size: 50, color: AppCores.deepBlue),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'EQUATORIAL',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            const Text(
              'APP CIDADÃO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _emailController,
              label: 'E-MAIL',
              hint: 'E-mail cadastrado',
              icon: Icons.person_outline,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Informe o e-mail' : null,
            ),
            const SizedBox(height: 25),
            _buildTextField(
              controller: _passwordController,
              label: 'SENHA',
              hint: '••••••••',
              icon: Icons.lock_outline,
              obscure: _obscurePassword,
              validator: (value) => (value == null || value.length < 8)
                  ? 'Senha muito curta'
                  : null,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: AppCores.neonBlue,
                      onChanged: (val) => setState(() => _rememberMe = val!),
                    ),
                    Text(
                      'Lembrar-me',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: Text(
                    'Esqueci a senha',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildMainButton(),
            const SizedBox(height: 30),
            _buildDivider(),
            const SizedBox(height: 30),
            _buildSignupButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildMainButton() {
    return Consumer<AutenticacaoController>(
      builder: (context, auth, _) => Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppCores.electricBlue, AppCores.neonBlue],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: auth.isLoading ? null : _handleLogin,
          child: Center(
            child: auth.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'ACESSAR SISTEMA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'ou',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  Widget _buildSignupButton() {
    return OutlinedButton(
      onPressed: _handleSignup,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        side: const BorderSide(color: AppCores.neonBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        'CRIAR NOVA CONTA',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 16,
        ),
      ),
    );
  }
}
