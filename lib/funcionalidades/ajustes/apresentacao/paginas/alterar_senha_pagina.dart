import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';

class TelaAlterarSenha extends StatefulWidget {
  const TelaAlterarSenha({super.key});

  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  final _formKey = GlobalKey<FormState>();

  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

  String? _validarSenha(String? value, {bool isConfirmacao = false}) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    if (!isConfirmacao) {
      if (value.length < 8) {
        return 'Mínimo 8 caracteres';
      }
      if (!value.contains(RegExp(r'[A-Z]'))) {
        return 'Inclua uma letra maiúscula';
      }
      if (!value.contains(RegExp(r'[a-z]'))) {
        return 'Inclua uma letra minúscula';
      }
      if (!value.contains(RegExp(r'[0-9]'))) {
        return 'Inclua um número';
      }
    } else {
      if (value != _novaSenhaController.text) {
        return 'As senhas não coincidem';
      }
    }
    return null;
  }

  void _handleUpdatePassword() {
    if (_formKey.currentState!.validate()) {
      // Simulação de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alterar Senha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sua nova senha deve seguir os critérios de segurança para proteger sua conta.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 25),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCampoSenha(
                          label: 'Senha atual',
                          controller: _senhaAtualController,
                          isObscured: _obscureSenhaAtual,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Informe a senha atual'
                              : null,
                          onToggleVisibility: () => setState(
                            () => _obscureSenhaAtual = !_obscureSenhaAtual,
                          ),
                        ),
                        const Divider(height: 30),
                        _buildCampoSenha(
                          label: 'Nova senha',
                          controller: _novaSenhaController,
                          isObscured: _obscureNovaSenha,
                          validator: (v) =>
                              _validarSenha(v), // Aplica regras complexas
                          onToggleVisibility: () => setState(
                            () => _obscureNovaSenha = !_obscureNovaSenha,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCampoSenha(
                          label: 'Confirmar nova senha',
                          controller: _confirmarSenhaController,
                          isObscured: _obscureConfirmarSenha,
                          validator: (v) => _validarSenha(
                            v,
                            isConfirmacao: true,
                          ), // Valida igualdade
                          onToggleVisibility: () => setState(
                            () => _obscureConfirmarSenha =
                                !_obscureConfirmarSenha,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _handleUpdatePassword,
                    child: const Text(
                      'ATUALIZAR SENHA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampoSenha({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required String? Function(String?) validator,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppCores.electricBlue,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppCores.neonBlue, width: 2),
        ),
      ),
    );
  }
}
