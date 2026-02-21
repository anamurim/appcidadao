import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //Variáveis
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  bool _emailEnviado = false;

  //Função referenciada no botão ENVIAR INSTRUÇÕES
  void _handleReset() async {
    // Valida o formulário antes de prosseguir
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      //Simula O envio do email
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _carregando = false;
        _emailEnviado = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose(); //Libera memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      //backgroundColor: AppCores.techGray,
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Recuperar Senha'),
      ),
      body: Stack(
        children: [
          // Background tecnológico
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  isDark
                      ? AppCores.deepBlue.withValues(alpha: 0.8)
                      : AppCores.lightGray.withValues(alpha: 0.8),
                ],
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
                        colors: [AppCores.electricBlue, AppCores.neonBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppCores.electricBlue.withValues(alpha: 0.6),
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

                const SizedBox(height: 10),

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
                  _emailEnviado
                      ? 'Enviamos um link de recuperação para o e-mail informado. Verifique sua caixa de entrada e spam.'
                      : 'Digite seu e-mail cadastrado e enviaremos um link para redefinir sua senha.',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 40),

                //Conecta o _emailController ao TextFormField dentro de um Form
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                      hintText: 'E-mail cadastrado',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || !value.contains('@'))
                        ? 'E-mail inválido'
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                // BOTÃO ENVIAR
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppCores.electricBlue, AppCores.neonBlue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppCores.electricBlue.withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _handleReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ENVIAR LINK DE RECUPERAÇÃO',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                //BOTÃO VOLTAR PARA LOGIN (INKWELL)
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleBackToLogin,
                      borderRadius: BorderRadius.circular(15),
                      splashColor: AppCores.neonBlue.withValues(alpha: 0.1),
                      highlightColor: AppCores.neonBlue.withValues(alpha: 0.05),
                      child: Center(
                        child: Text(
                          'VOLTAR PARA LOGIN',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Informações de segurança
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppCores.deepBlue.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppCores.neonBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            size: 24,
                            color: AppCores.accentGreen,
                          ),
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
                        '• Verifique sua caixa de spam se não encontrar\n'
                        '   o e-mail\n'
                        '• Mantenha sua senha em local seguro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Informações de suporte
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Precisa de ajuda?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'suporte@equatorial.com',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
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

  void _handleBackToLogin() {
    Navigator.pushReplacementNamed(context, '/');
  }
}
