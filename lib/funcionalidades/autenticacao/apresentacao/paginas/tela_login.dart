import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/widgets/linha_conexao.dart';

class TechLoginScreen extends StatefulWidget {
  const TechLoginScreen({super.key});

  @override
  State<TechLoginScreen> createState() => _TechLoginScreenState();
}

class _TechLoginScreenState extends State<TechLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulação de processo de login
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navegar para a tela inicial após login bem-sucedido
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.deepBlue,

      body: Stack(
        children: [
          //O fundo tecnológico (fica atrás de tudo)
          _buildTechBackground(),

          //O conteúdo real dentro do SafeArea
          SafeArea(
            child: GestureDetector(
              // Isso faz com que o teclado feche ao clicar fora dos campos
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  //Espaço entre os elementos e a borda da tela?
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Form(
                    //key: _formKey,
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
          ),
        ],
      ),
    );
  }

  Widget _buildTechBackground() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                //Cores do plano de fundo que formam um degradê
                AppCores.deepBlue.withValues(alpha: 0.8),
                AppCores.techGray,
              ],
              stops: const [0.1, 0.8],
            ),
          ),
        ),
        // Partículas movidas para widget separado conforme solicitado na estrutura
        ..._buildParticles(),
        CustomPaint(
          painter: ConnectionLinesPainter(
            //Linhas do plano de fundo
            color: AppCores.electricBlue.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildParticles() {
    return [
      Positioned(top: 100, left: 50, child: _buildParticle(4, 0.6)),
      Positioned(top: 200, right: 80, child: _buildParticle(3, 0.8, true)),
      Positioned(top: 300, left: 100, child: _buildParticle(2, 0.4)),
    ];
  }

  Widget _buildParticle(double size, double opacity, [bool neon = false]) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: neon
            ? AppCores.neonBlue.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  //Header: Nome com "Raio"
  Widget _buildHeader(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      //Tamanho do Header
      height: height * 0.35,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          //Cores em degradê do Header
          colors: [AppCores.deepBlue, AppCores.electricBlue, AppCores.neonBlue],
          stops: [0.1, 0.5, 0.9],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            //Sombra do Header
            color: AppCores.electricBlue.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    //Sombra base do Header
                    color: AppCores.techGray.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Center(
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
                        //Cores do simbolo "raio"
                        Colors.white,
                        AppCores.neonBlue.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        //Sombra contorno do circulo do "raio"
                        color: AppCores.electricBlue.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.bolt,
                          size: 50,
                          color: AppCores.deepBlue,
                          shadows: [
                            Shadow(
                              //Contorno do símbolo do raio
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [Colors.white, AppCores.neonBlue, Colors.white],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'EQUATORIAL',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'APP CIDADÃO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(
              controller: _emailController,
              label: 'E-MAIL',
              hint: 'E-mail cadastrado',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 25),
            _buildTextField(
              controller: _passwordController,
              label: 'SENHA',
              hint: '••••••••',
              icon: Icons.lock_outline,
              obscure: _obscurePassword,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppCores.neonBlue,
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
                      // Cor do fundo quando selecionado
                      activeColor: AppCores.neonBlue,
                      // Cor do ícone de "check" interno
                      checkColor: AppCores.deepBlue,
                      // Configuração da borda (quando desmarcado e contorno do marcado)
                      side: BorderSide(
                        color: AppCores.neonBlue.withValues(alpha: 0.8),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) => setState(() => _rememberMe = val!),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Lembrar-me',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text(
                    'Esqueci a senha',
                    style: TextStyle(
                      color: AppCores.neonBlue,
                      fontWeight: FontWeight.w600,
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
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppCores.lightGray.withValues(alpha: 0.8),
        labelText: label,
        labelStyle: const TextStyle(
          color: AppCores.neonBlue,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppCores.neonBlue),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppCores.neonBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppCores.electricBlue, AppCores.neonBlue],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppCores.electricBlue.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: _isLoading ? null : _handleLogin,
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'ACESSAR SISTEMA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'ou',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
      ],
    );
  }

  Widget _buildSignupButton() {
    return OutlinedButton(
      onPressed: _handleSignup,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        side: BorderSide(
          color: AppCores.neonBlue.withValues(alpha: 0.5),
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        'CRIAR NOVA CONTA',
        style: TextStyle(color: AppCores.neonBlue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
