import 'package:flutter/material.dart';
import '../../../core/constantes/cores.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose(); // Boa prática: liberar memória
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
          key: _formKey, // Conectando o GlobalKey
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.lock_reset, size: 80, color: AppCores.neonBlue),
              const SizedBox(height: 20),
              Text(
                _emailSent
                    ? 'Verifique seu e-mail!'
                    : 'Informe seu e-mail para receber as instruções.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // 3. Conectando o _emailController ao TextFormField
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppCores.lightGray.withValues(alpha: 0.3),
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(color: Colors.white38),
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

              // 4. Usando _isLoading e _handleReset
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ENVIAR INSTRUÇÕES'),
                ),
              ),

              if (_emailSent)
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
