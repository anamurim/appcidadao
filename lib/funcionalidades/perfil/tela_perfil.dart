import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Adicionado
import 'package:flutter/services.dart';
import '../../core/constantes/cores.dart';
import '../home/controladores/usuario_controller.dart';

class TelaPerfil extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TelaPerfil({super.key, this.onBackToHome});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _formKey = GlobalKey<FormState>();

  // Controladores sincronizados com SignupScreen
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cepController = TextEditingController(); // Novo
  final _enderecoController = TextEditingController(); // Novo
  //final _passwordController = TextEditingController(); // Senha será alterada em outra tela.

  // Máscaras sincronizadas com SignupScreen
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

  bool _dadosCarregados = false;
  bool _salvando = false;
  //bool _obscurePassword = true; // Para o novo campo de senha

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dadosCarregados) {
      final usuario = context.read<UsuarioController>().usuario;
      if (usuario != null) {
        _nomeController.text = usuario.nome;
        _emailController.text = usuario.email;
        _telefoneController.text = _phoneMask.maskText(usuario.telefone ?? '');
        _cpfController.text = _cpfMask.maskText(usuario.cpf ?? '');
        _enderecoController.text = usuario.endereco!;
        // Caso seu modelo de usuário já tenha estes campos:
        // _cepController.text = _cepMask.maskText(usuario.cep ?? '');
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
    _cepController.dispose();
    _enderecoController.dispose();
    //_passwordController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final usuarioAtual = context.read<UsuarioController>().usuario;
    if (usuarioAtual == null) return;

    // Atualizado para incluir os novos campos no salvamento
    final usuarioAtualizado = usuarioAtual.copyWith(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _phoneMask.getUnmaskedText(),
      cpf: _cpfMask.getUnmaskedText(),
      // Adicione cep e senha se o seu método copyWith/Modelo suportar:
      // cep: _cepMask.getUnmaskedText(),
      // senha: _passwordController.text,
    );

    await context.read<UsuarioController>().atualizarUsuario(usuarioAtualizado);

    if (mounted) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados salvos com sucesso!'),
          backgroundColor: Colors.green,
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
                        // Avatar e Nome (Mantidos da TelaPerfil original)
                        _buildHeader(usuario),

                        const SizedBox(height: 30),

                        _buildSecao(
                          titulo: 'Dados Pessoais e Localização',
                          children: [
                            _campo(
                              'Nome completo',
                              Icons.person_outline,
                              _nomeController,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Informe o nome'
                                  : null,
                            ),
                            _campo(
                              'E-mail',
                              Icons.email_outlined,
                              _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (valida) {
                                if (valida == null || valida.isEmpty) {
                                  return 'Informe o e-mail';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(valida)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                            _campo(
                              'CPF',
                              Icons.badge_outlined,
                              _cpfController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_cpfMask],
                            ),
                            _campo(
                              'Telefone',
                              Icons.phone_outlined,
                              _telefoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [_phoneMask],
                            ),
                            _campo(
                              'CEP',
                              Icons.location_on_outlined,
                              _cepController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_cepMask],
                            ),
                            _campo(
                              'Endereço',
                              Icons.location_on_outlined,
                              _enderecoController,
                              //keyboardType: TextInputType.number,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /*A senha será alterada em outra tela (AlterarSenhaPagina 
                        em Configurações) para seguir boas práticas de segurança, 
                        mas aqui está um exemplo de como poderia ser adicionado:

                        _buildSecao(
                          titulo: 'Segurança',
                          children: [
                            _campo(
                              'Alterar Senha',
                              Icons.lock_outline,
                              _passwordController,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              toggleVisibility: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              helperText: 'Deixe em branco para não alterar',
                            ),
                          ],
                        ),*/
                        const SizedBox(height: 30),

                        _buildBotaoSalvar(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  // Widgets auxiliares para manter o código limpo
  Widget _buildHeader(dynamic usuario) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: (usuario != null && usuario.avatar.isNotEmpty)
              ? NetworkImage(usuario.avatar)
              : null,
          backgroundColor: Colors.grey[300],
          child: (usuario == null || usuario.avatar.isEmpty)
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 12),
        // Aplicando as chaves nos ifs de retorno de texto para seguir o linter
        if (usuario != null) ...{
          Text(
            usuario.nome,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(usuario.email, style: const TextStyle(color: Colors.grey)),
        } else ...{
          const Text(
            'Usuário',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        },
      ],
    );
  }

  Widget _buildBotaoSalvar() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.neonBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: _salvando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save, color: Colors.white),
        label: Text(
          _salvando ? 'Salvando...' : 'Salvar alterações',
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: _salvando ? null : _salvarAlteracoes,
      ),
    );
  }

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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppCores.neonBlue,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _campo(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon, color: AppCores.neonBlue),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppCores.neonBlue, width: 2),
          ),
        ),
      ),
    );
  }
}
