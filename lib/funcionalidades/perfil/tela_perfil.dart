import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constantes/cores.dart';
import '../home/controladores/usuario_controller.dart';
//import '../../core/modelos/usuario.dart';

class TelaPerfil extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TelaPerfil({super.key, this.onBackToHome});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();

  bool _dadosCarregados = false;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dadosCarregados) {
      final usuario = context.read<UsuarioController>().usuario;
      if (usuario != null) {
        _nomeController.text = usuario.nome;
        _emailController.text = usuario.email;
        _telefoneController.text = usuario.telefone ?? '';
        _cpfController.text = usuario.cpf ?? '';
      }
      _dadosCarregados = true;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final usuarioAtual = context.read<UsuarioController>().usuario;
    if (usuarioAtual == null) return;

    final usuarioAtualizado = usuarioAtual.copyWith(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim().isNotEmpty
          ? _telefoneController.text.trim()
          : null,
      cpf: _cpfController.text.trim().isNotEmpty
          ? _cpfController.text.trim()
          : null,
    );

    await context.read<UsuarioController>().atualizarUsuario(usuarioAtualizado);

    if (mounted) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Dados salvos com sucesso!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioController>(
      builder: (context, controller, _) {
        final usuario = controller.usuario;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // FOTO + NOME
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  usuario != null && usuario.avatar.isNotEmpty
                                  ? NetworkImage(usuario.avatar)
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: usuario == null || usuario.avatar.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              usuario?.nome ?? 'Usuário',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              usuario?.email ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // DADOS PESSOAIS
                        _buildSecao(
                          titulo: 'Dados Pessoais',
                          children: [
                            _campo(
                              'Nome completo',
                              Icons.person,
                              _nomeController,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Informe o nome'
                                  : null,
                            ),
                            _campo(
                              'E-mail',
                              Icons.email,
                              _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Informe o e-mail'
                                  : null,
                            ),
                            _campo(
                              'Telefone',
                              Icons.phone,
                              _telefoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            _campo(
                              'CPF',
                              Icons.badge,
                              _cpfController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // BOTÃO SALVAR
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: _salvando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              _salvando ? 'Salvando...' : 'Salvar alterações',
                            ),
                            onPressed: _salvando ? null : _salvarAlteracoes,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  // SEÇÃO
  static Widget _buildSecao({
    required String titulo,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // CAMPO PADRÃO
  static Widget _campo(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
