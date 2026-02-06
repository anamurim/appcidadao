import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart'; // Mantendo seu padrão de cores

class TelaAlterarSenha extends StatefulWidget {
  const TelaAlterarSenha({super.key});

  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  // Controles para os campos de texto
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Variáveis para controlar a visibilidade das senhas
  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sua nova senha deve ser diferente das senhas utilizadas anteriormente.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 25),

              // Card com os campos de entrada (Seguindo o padrão do seu telaperfil.dart)
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
                        onToggleVisibility: () {
                          setState(
                            () => _obscureSenhaAtual = !_obscureSenhaAtual,
                          );
                        },
                      ),
                      const Divider(height: 30),
                      _buildCampoSenha(
                        label: 'Nova senha',
                        controller: _novaSenhaController,
                        isObscured: _obscureNovaSenha,
                        onToggleVisibility: () {
                          setState(
                            () => _obscureNovaSenha = !_obscureNovaSenha,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildCampoSenha(
                        label: 'Confirmar nova senha',
                        controller: _confirmarSenhaController,
                        isObscured: _obscureConfirmarSenha,
                        onToggleVisibility: () {
                          setState(
                            () => _obscureConfirmarSenha =
                                !_obscureConfirmarSenha,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Botão de Ação (Baseado no seu telaperfil.dart)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCores.electricBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Lógica de validação e salvamento
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Senha atualizada com sucesso!'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ATUALIZAR SENHA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir os campos de senha com ícone de "olho"
  Widget _buildCampoSenha({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
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
