import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equatorial Tech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TechLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}

// TELA DE LOGIN
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

  // Cores para o tema tecnológico
  final Color _deepBlue = const Color(0xFF001A4D);
  final Color _electricBlue = const Color(0xFF0066FF);
  final Color _neonBlue = const Color(0xFF00BFFF);
  final Color _techGray = const Color(0xFF1A1A2E);
  final Color _lightGray = const Color(0xFF2D3047);
  final Color _accentGreen = const Color(0xFF00FF88);

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulação de processo de login
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navegar para a tela inicial após login bem-sucedido
      Navigator.pushReplacementNamed(context, '/home');
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _techGray,
      body: Stack(
        children: [
          _buildTechBackground(),
          SingleChildScrollView(
            child: SizedBox(
              height: screenHeight,
              child: Column(
                children: [
                  _buildHeader(screenHeight),
                  Expanded(child: _buildLoginForm()),
                ],
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
              colors: [_deepBlue.withOpacity(0.8), _techGray],
              stops: const [0.1, 0.8],
            ),
          ),
        ),
        ..._buildParticles(),
        CustomPaint(
          painter: ConnectionLinesPainter(
            color: _electricBlue.withOpacity(0.2),
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
            ? _neonBlue.withOpacity(opacity)
            : Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeader(double height) {
    return Container(
      height: height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_deepBlue, _electricBlue, _neonBlue],
          stops: const [0.1, 0.5, 0.9],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: _electricBlue.withOpacity(0.4),
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
                    color: _deepBlue.withOpacity(0.3),
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
                      colors: [Colors.white, _neonBlue.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _electricBlue.withOpacity(0.6),
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
                          color: _deepBlue,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
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
                      colors: [Colors.white, _neonBlue, Colors.white],
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
                    color: Colors.white.withOpacity(0.8),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _electricBlue.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _lightGray.withOpacity(0.8),
                  hintText: 'usuário@equatorial.com',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  labelText: 'E-MAIL',
                  labelStyle: TextStyle(
                    color: _neonBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  prefixIcon: Icon(Icons.person_outline, color: _neonBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: _neonBlue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _electricBlue.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _lightGray.withOpacity(0.8),
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 20,
                    letterSpacing: 5,
                  ),
                  labelText: 'SENHA',
                  labelStyle: TextStyle(
                    color: _neonBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color: _neonBlue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _neonBlue,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: _neonBlue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _neonBlue, width: 2),
                          color: _rememberMe ? _neonBlue : Colors.transparent,
                        ),
                        child: _rememberMe
                            ? Icon(Icons.check, size: 18, color: _deepBlue)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Lembrar-me',
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: Text(
                    'Esqueci a senha',
                    style: TextStyle(
                      color: _neonBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_electricBlue, _neonBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _electricBlue.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: _isLoading ? null : _handleLogin,
                  borderRadius: BorderRadius.circular(15),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ACESSAR SISTEMA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'ou',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _neonBlue.withOpacity(0.5), width: 2),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: _handleSignup,
                  borderRadius: BorderRadius.circular(15),
                  splashColor: _neonBlue.withOpacity(0.1),
                  highlightColor: _neonBlue.withOpacity(0.05),
                  child: Center(
                    child: Text(
                      'CRIAR NOVA CONTA',
                      style: TextStyle(
                        color: _neonBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 16, color: _accentGreen),
                    const SizedBox(width: 8),
                    Text(
                      'Conexão segura • SSL/TLS',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'v3.2.1 • © 2024 Equatorial Tech',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// TELA DE ESQUECEU A SENHA
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  // Cores para o tema tecnológico
  final Color _deepBlue = const Color(0xFF001A4D);
  final Color _electricBlue = const Color(0xFF0066FF);
  final Color _neonBlue = const Color(0xFF00BFFF);
  final Color _techGray = const Color(0xFF1A1A2E);
  final Color _lightGray = const Color(0xFF2D3047);
  final Color _accentGreen = const Color(0xFF00FF88);

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulação de processo de recuperação de senha
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  void _handleBackToLogin() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _techGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recuperar Senha',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          // Background tecnológico
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [_deepBlue.withOpacity(0.8), _techGray],
                stops: const [0.1, 0.8],
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Ícone de segurança
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [_deepBlue, _electricBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _electricBlue.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_reset,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Título
                Text(
                  'Recuperar Senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Descrição
                Text(
                  _emailSent
                      ? 'Enviamos um link de recuperação para o e-mail informado. Verifique sua caixa de entrada e spam.'
                      : 'Digite seu e-mail cadastrado e enviaremos um link para redefinir sua senha.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 40),

                if (!_emailSent) _buildResetForm(),
                if (_emailSent) _buildSuccessMessage(),

                const SizedBox(height: 30),

                // Botão para voltar ao login
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _neonBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: _handleBackToLogin,
                      borderRadius: BorderRadius.circular(15),
                      splashColor: _neonBlue.withOpacity(0.1),
                      highlightColor: _neonBlue.withOpacity(0.05),
                      child: Center(
                        child: Text(
                          'VOLTAR PARA LOGIN',
                          style: TextStyle(
                            color: _neonBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Informações de segurança
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: _neonBlue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security, size: 24, color: _accentGreen),
                          const SizedBox(width: 12),
                          Text(
                            'Dicas de segurança',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• O link de recuperação é válido por 24 horas\n'
                        '• Não compartilhe o link com outras pessoas\n'
                        '• Verifique sua caixa de spam se não encontrar o e-mail\n'
                        '• Mantenha sua senha em local seguro',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Informações de suporte
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Precisa de ajuda?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'suporte@equatorial.com',
                        style: TextStyle(
                          color: _neonBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _electricBlue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: _lightGray.withOpacity(0.8),
                hintText: 'seu@email.com',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                labelText: 'E-MAIL CADASTRADO',
                labelStyle: TextStyle(
                  color: _neonBlue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                prefixIcon: Icon(Icons.email_outlined, color: _neonBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: _neonBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite seu e-mail';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_electricBlue, _neonBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _electricBlue.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: _isLoading ? null : _handleResetPassword,
                borderRadius: BorderRadius.circular(15),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ENVIAR LINK DE RECUPERAÇÃO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
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

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentGreen.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: _accentGreen),
          const SizedBox(height: 20),
          Text(
            'E-mail Enviado!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Verifique sua caixa de entrada do e-mail $email para redefinir sua senha.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String get email {
    return _emailController.text.isNotEmpty
        ? _emailController.text
        : 'informado';
  }
}

// TELA INICIAL APÓS LOGIN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  // Cores para o tema tecnológico
  final Color _deepBlue = const Color(0xFF001A4D);
  final Color _electricBlue = const Color(0xFF0066FF);
  final Color _neonBlue = const Color(0xFF00BFFF);
  final Color _techGray = const Color(0xFF1A1A2E);
  final Color _lightGray = const Color(0xFF2D3047);
  final Color _accentGreen = const Color(0xFF00FF88);

  // Dados do usuário (simulação)
  final Map<String, dynamic> _userData = {
    'name': 'Flaviane Guimarães',
    'email': 'eng.flavianeguimaraes@gmail.com',
    'account': '12345-6',
    'avatar':
        'https://ui-avatars.com/api/?name=Carlos+Silva&background=0066FF&color=fff',
  };

  // Lista de funcionalidades
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Minha Conta',
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFF0066FF),
      'description': 'Verificar saldo e faturas',
    },
    {
      'title': 'Consumo',
      'icon': Icons.show_chart,
      'color': Color(0xFF00BFFF),
      'description': 'Monitorar consumo de energia',
    },
    {
      'title': 'Pagamentos',
      'icon': Icons.payment,
      'color': Color(0xFF00FF88),
      'description': 'Pagar contas e agendar',
    },
    {
      'title': 'Suporte',
      'icon': Icons.support_agent,
      'color': Color(0xFFFF6B6B),
      'description': 'Falar com atendente',
    },
    {
      'title': 'Falta de Energia',
      'icon': Icons.power_off,
      'color': Color(0xFFFFA726),
      'description': 'Reportar problemas',
    },
    {
      'title': 'Economia',
      'icon': Icons.eco,
      'color': Color(0xFF4CAF50),
      'description': 'Dicas para economizar',
    },
    // Novas funcionalidades de problemas urbanos
    {
      'title': 'Interferência na Via',
      'icon': Icons.traffic,
      'color': Color(0xFF9C27B0),
      'description': 'Reportar interferências na via pública',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Semáforo',
      'icon': Icons.traffic_outlined,
      'color': Color(0xFFFF9800),
      'description': 'Problemas com semáforos',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Veículo Quebrado',
      'icon': Icons.car_repair,
      'color': Color(0xFF795548),
      'description': 'Reportar veículo quebrado na via',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Estacionamento Irregular',
      'icon': Icons.local_parking,
      'color': Color(0xFF607D8B),
      'description': 'Estacionamento irregular',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Sinalização',
      'icon': Icons.signpost,
      'color': Color(0xFF009688),
      'description': 'Problemas com sinalização',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Iluminação Pública',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFFFFC107),
      'description': 'Problemas com iluminação pública',
      'category': 'problemas_urbanos',
    },
  ];

  // Lista de notificações
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Fatura disponível',
      'message': 'Sua fatura de janeiro está disponível para pagamento',
      'time': 'Há 2 dias',
      'read': false,
    },
    {
      'title': 'Pagamento confirmado',
      'message': 'Seu pagamento de dezembro foi confirmado',
      'time': 'Há 5 dias',
      'read': true,
    },
    {
      'title': 'Manutenção programada',
      'message': 'Manutenção na sua região dia 15/01',
      'time': 'Há 1 semana',
      'read': true,
    },
  ];

  // Lista de telas do bottom navigation
  final List<Widget> _pages = [
    // Página 0 será definida no build
    Container(), // Placeholder
    Container(color: Colors.red), // Página 2
    Container(color: Colors.green), // Página 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _lightGray,
        title: Text('Sair do App', style: TextStyle(color: Colors.white)),
        content: Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCELAR', style: TextStyle(color: _neonBlue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              Navigator.pushReplacementNamed(context, '/'); // Volta para login
            },
            style: ElevatedButton.styleFrom(backgroundColor: _neonBlue),
            child: Text('SAIR'),
          ),
        ],
      ),
    );
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
      }
    });
  }

  List<Map<String, dynamic>> get _filteredFeatures {
    if (_searchController.text.isEmpty) {
      return _features;
    }

    final query = _searchController.text.toLowerCase();
    return _features.where((feature) {
      return feature['title'].toLowerCase().contains(query) ||
          feature['description'].toLowerCase().contains(query) ||
          (feature['category']?.toString().toLowerCase() ?? '').contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _techGray,
      appBar: AppBar(
        backgroundColor: _deepBlue,
        elevation: 0,
        title: _showSearchBar
            ? _buildSearchField()
            : Text(
                'APP CIDADÃO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: _buildAppBarActions(),
      ),
      body: _buildHomePage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saudação e informações do usuário
          _buildUserInfo(),
          const SizedBox(height: 24),

          // Cards de funcionalidades
          _buildFeaturesGrid(),
          const SizedBox(height: 24),

          // Últimas notificações
          _buildNotifications(),
          const SizedBox(height: 24),

          // Informações da conta
          _buildAccountInfo(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_deepBlue, _electricBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _electricBlue.withOpacity(0.3),
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
              border: Border.all(color: _neonBlue, width: 2),
            ),
            child: Center(
              child: Icon(Icons.person, size: 40, color: _deepBlue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${_userData['name']}!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userData['email'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
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
                    color: _neonBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _neonBlue, width: 1),
                  ),
                  child: Text(
                    'Conta: ${_userData['account']}',
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

  Widget _buildFeaturesGrid() {
    final problemasUrbanos = _filteredFeatures
        .where((feature) => feature['category'] == 'problemas_urbanos')
        .toList();
    final outrasFuncionalidades = _filteredFeatures
        .where((feature) => feature['category'] != 'problemas_urbanos')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_searchController.text.isNotEmpty)
          Text(
            'Resultados da busca: ${_filteredFeatures.length} encontrados',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        if (_searchController.text.isNotEmpty) const SizedBox(height: 12),

        if (outrasFuncionalidades.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Funcionalidades Principais',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: outrasFuncionalidades.length,
                itemBuilder: (context, index) {
                  final feature = outrasFuncionalidades[index];
                  return _buildFeatureCard(feature);
                },
              ),
            ],
          ),

        if (problemasUrbanos.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Problemas Urbanos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: problemasUrbanos.length,
            itemBuilder: (context, index) {
              final feature = problemasUrbanos[index];
              return _buildFeatureCard(feature);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _neonBlue.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            _showFeatureDetails(feature);
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: feature['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      feature['icon'],
                      color: feature['color'],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notificações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                _showAllNotifications();
              },
              child: Text('Ver todas', style: TextStyle(color: _neonBlue)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._notifications.take(2).map((notification) {
          return _buildNotificationItem(notification);
        }).toList(),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !notification['read']
              ? _neonBlue.withOpacity(0.3)
              : Colors.transparent,
          width: !notification['read'] ? 2 : 0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: !notification['read'] ? _neonBlue : Colors.transparent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            notification['time'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _neonBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo da Conta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Última Fatura', 'R\$ 250,45', Icons.receipt),
          const SizedBox(height: 12),
          _buildInfoItem('Vencimento', '05/02/2024', Icons.calendar_today),
          const SizedBox(height: 12),
          _buildInfoItem(
            'Status',
            'Em dia',
            Icons.check_circle,
            color: _accentGreen,
          ),
          const SizedBox(height: 12),
          _buildInfoItem('Próxima Leitura', '15/02/2024', Icons.speed),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_electricBlue, _neonBlue]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  // Ação de pagar fatura
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'PAGAR FATURA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color ?? _neonBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Buscar funcionalidades...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: _neonBlue),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7)),
            onPressed: _toggleSearchBar,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {});
        },
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
        icon: Icon(Icons.notifications_outlined, color: Colors.white),
        onPressed: () {
          _showNotifications();
        },
      ),
      IconButton(
        icon: Icon(Icons.logout_outlined, color: Colors.white),
        onPressed: _logout,
      ),
    ];
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: _deepBlue,
        border: Border(top: BorderSide(color: _neonBlue.withOpacity(0.2))),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: _neonBlue,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            activeIcon: Icon(Icons.insert_chart),
            label: 'Consumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }

  void _showFeatureDetails(Map<String, dynamic> feature) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _lightGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: feature['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    feature['icon'],
                    color: feature['color'],
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                feature['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                feature['description'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      feature['color'],
                      feature['color'].withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para a funcionalidade específica
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'ACESSAR ${feature['title'].toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'FECHAR',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _lightGray,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notificações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _techGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.notifications,
                                color: !notification['read']
                                    ? _neonBlue
                                    : Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification['message'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      notification['time'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _techGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          // Marcar todas como lidas
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'MARCAR TODAS COMO LIDAS',
                              style: TextStyle(
                                color: _neonBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllNotifications() {
    _showNotifications();
  }
}

// TELA DE CADASTRO (mantida igual, mas com navegação ajustada)
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  // Cores para o tema tecnológico
  final Color _deepBlue = const Color(0xFF001A4D);
  final Color _electricBlue = const Color(0xFF0066FF);
  final Color _neonBlue = const Color(0xFF00BFFF);
  final Color _techGray = const Color(0xFF1A1A2E);
  final Color _lightGray = const Color(0xFF2D3047);
  final Color _accentGreen = const Color(0xFF00FF88);

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange[800],
            content: Text('Você precisa aceitar os termos de uso!'),
          ),
        );
        return;
      }

      // Simulação de cadastro
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: _lightGray,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_neonBlue),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Criando sua conta...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context); // Fecha o loading

      // Mostra sucesso e volta para login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _lightGray,
          title: Row(
            children: [
              Icon(Icons.check_circle, color: _accentGreen),
              const SizedBox(width: 10),
              Text(
                'Conta Criada!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Sua conta foi criada com sucesso! Faça login para continuar.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
                Navigator.pop(context); // Volta para tela de login
              },
              child: Text(
                'IR PARA LOGIN',
                style: TextStyle(color: _neonBlue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _techGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Criar Nova Conta',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Preencha seus dados',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Campo Nome Completo
              _buildTextField(
                controller: _nameController,
                label: 'NOME COMPLETO',
                hintText: 'Digite seu nome completo',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu nome';
                  }
                  if (value.length < 3) {
                    return 'Nome muito curto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo E-mail
              _buildTextField(
                controller: _emailController,
                label: 'E-MAIL',
                hintText: 'seu@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo CPF
              _buildTextField(
                controller: _cpfController,
                label: 'CPF',
                hintText: '000.000.000-00',
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu CPF';
                  }
                  if (value.length < 11) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Telefone
              _buildTextField(
                controller: _phoneController,
                label: 'TELEFONE',
                hintText: '(00) 00000-0000',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu telefone';
                  }
                  if (value.length < 11) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Senha
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: _electricBlue.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _lightGray.withOpacity(0.8),
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 20,
                      letterSpacing: 5,
                    ),
                    labelText: 'SENHA',
                    labelStyle: TextStyle(
                      color: _neonBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: _neonBlue),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _neonBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _neonBlue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite uma senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Campo Confirmar Senha
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: _electricBlue.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _lightGray.withOpacity(0.8),
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 20,
                      letterSpacing: 5,
                    ),
                    labelText: 'CONFIRMAR SENHA',
                    labelStyle: TextStyle(
                      color: _neonBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_reset_outlined,
                      color: _neonBlue,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _neonBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: _neonBlue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),

              // Termos de uso
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreeTerms = !_agreeTerms;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _neonBlue, width: 2),
                        color: _agreeTerms ? _neonBlue : Colors.transparent,
                      ),
                      child: _agreeTerms
                          ? Icon(Icons.check, size: 18, color: _deepBlue)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'Eu concordo com os '),
                          TextSpan(
                            text: 'Termos de Uso',
                            style: TextStyle(
                              color: _neonBlue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(
                              color: _neonBlue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' da Equatorial Tech'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Botão de cadastro
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_electricBlue, _neonBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: _electricBlue.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: _handleSignup,
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        'CRIAR CONTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Link para voltar ao login
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Já tem uma conta? Faça login',
                    style: TextStyle(
                      color: _neonBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Informações de segurança
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _neonBlue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, size: 20, color: _accentGreen),
                        const SizedBox(width: 10),
                        Text(
                          'Segurança da conta',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Sua senha deve ter pelo menos 6 caracteres\n'
                      '• Use letras, números e caracteres especiais\n'
                      '• Não compartilhe sua senha com ninguém\n'
                      '• Seus dados são criptografados e protegidos',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _electricBlue.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: _lightGray.withOpacity(0.8),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          labelText: label,
          labelStyle: TextStyle(
            color: _neonBlue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          prefixIcon: Icon(prefixIcon, color: _neonBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: _neonBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          errorStyle: TextStyle(color: Colors.red[200]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

// Custom painter para linhas de conexão tecnológicas
class ConnectionLinesPainter extends CustomPainter {
  final Color color;

  ConnectionLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 20; i++) {
      final double x = i * 60.0;
      final double y = i * 40.0;

      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(size.width, y)
        ..moveTo(0, y)
        ..lineTo(x, size.height);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
