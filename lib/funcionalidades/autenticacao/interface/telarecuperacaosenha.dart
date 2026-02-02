import 'package:flutter/material.dart';
import '../../../core/constantes/cores.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
<<<<<<< HEAD
  //Variáveis
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  bool _emailEnviado = false;

  //Função referenciada no botão ENVIAR INSTRUÇÕES
  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      //Simula O envio do email
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _carregando = false;
        _emailEnviado = true;
=======
  // 1. Campos agora utilizados
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  // 2. Função agora referenciada no botão
  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulação de envio
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
      });
    }
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _emailController.dispose(); //Libera memória: boas práticas
=======
    _emailController.dispose(); // Boa prática: liberar memória
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Recuperar Senha'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
<<<<<<< HEAD
          key: _formKey, //Conectando o GlobalKey
=======
          key: _formKey, // Conectando o GlobalKey
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.lock_reset, size: 80, color: AppCores.neonBlue),
              const SizedBox(height: 20),
              Text(
<<<<<<< HEAD
                _emailEnviado
=======
                _emailSent
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
                    ? 'Verifique seu e-mail!'
                    : 'Informe seu e-mail para receber as instruções.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),

<<<<<<< HEAD
              //Conecta o _emailController ao TextFormField
=======
              // 3. Conectando o _emailController ao TextFormField
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppCores.lightGray.withValues(alpha: 0.3),
                  hintText: 'E-mail',
<<<<<<< HEAD
                  hintStyle: const TextStyle(color: Colors.white),
=======
                  hintStyle: const TextStyle(color: Colors.white38),
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
                  prefixIcon: const Icon(Icons.email, color: AppCores.neonBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'E-mail inválido'
                    : null,
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
              //Uso de _carregando e _handleReset
=======
              // 4. Usando _isLoading e _handleReset
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
<<<<<<< HEAD
                  onPressed: _carregando ? null : _handleReset,
=======
                  onPressed: _isLoading ? null : _handleReset,
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
<<<<<<< HEAD
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'ENVIAR INSTRUÇÕES',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),

              if (_emailEnviado)
=======
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ENVIAR INSTRUÇÕES'),
                ),
              ),

              if (_emailSent)
>>>>>>> 9d542fcb6b2577d635cfeab19dbbd82c52872958
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar para o Login',
                    style: TextStyle(color: AppCores.neonBlue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
