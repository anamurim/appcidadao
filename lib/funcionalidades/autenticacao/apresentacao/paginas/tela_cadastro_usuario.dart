import 'package:flutter/material.dart';
import '../../../../core/constantes/cores.dart';
import '../../../../core/utilitarios/funcoes_auxiliares.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _showSearchBar = false;
  bool _isLoading = false;
  bool _aceitaTermos = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  // FocusNodes para navegação entre campos
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (!_aceitaTermos) {
        setState(() => _errorMessage = 'Por favor, aceite os termos de uso');
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Simulação de cadastro
        // Exibe o diálogo de carregamento
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppCores.lightGray,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppCores.neonBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Criando sua conta...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        Navigator.pop(context);

        // Simulação de possíveis erros
        if (_emailController.text.contains('exemplo@teste.com')) {
          throw 'E-mail já cadastrado';
        }

        setState(() => _errorMessage = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          setState(() => _errorMessage = e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /*bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _cpfController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _aceitaTermos;
  }*/

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _searchController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _cpfFocus.dispose();
    _phoneFocus.dispose();
    _cepFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.techGray,
      appBar: AppBar(
        title: _showSearchBar
            ? FuncoesAuxiliares.construirCampoBusca(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                onClear: () {
                  setState(() {
                    _showSearchBar = false;
                    _searchController.clear();
                  });
                },
              )
            : const Text(
                'Criar Nova Conta',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
        backgroundColor: AppCores.techGray,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppCores.neonBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppCores.neonBlue),
                ),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    if (_errorMessage != null) _buildErrorBanner(),
                    const SizedBox(height: 10),
                    const Text(
                      'Preencha os dados abaixo para se cadastrar',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    // Campo Nome Completo
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome completo',
                      icon: Icons.person_outline,
                      focusNode: _nameFocus,
                      nextFocus: _emailFocus,
                    ),
                    const SizedBox(height: 16),

                    // Campo E-mail
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                      focusNode: _emailFocus,
                      nextFocus: _cpfFocus,
                      isEmail: true,
                    ),
                    const SizedBox(height: 16),

                    // Campo CPF
                    _buildTextField(
                      controller: _cpfController,
                      label: 'CPF',
                      icon: Icons.badge_outlined,
                      focusNode: _cpfFocus,
                      nextFocus: _phoneFocus,
                    ),
                    const SizedBox(height: 16),

                    // Campo Telefone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Telefone',
                      icon: Icons.phone_outlined,
                      focusNode: _phoneFocus,
                      nextFocus: _cepFocus,
                    ),
                    const SizedBox(height: 16),

                    // Campo CEP
                    _buildTextField(
                      controller: _cepController,
                      label: 'CEP',
                      icon: Icons.location_on_outlined,
                      focusNode: _cepFocus,
                      nextFocus: _passwordFocus,
                    ),
                    const SizedBox(height: 16),

                    // Campo Senha
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      toggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 16),

                    // Campo Confirmar Senha
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar Senha',
                      icon: Icons.lock_reset_outlined,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      focusNode: _confirmPasswordFocus,
                      isConfirmPassword: true,
                      toggleVisibility: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildTermosCheckbox(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 30),
                    _buildLoginLink(),
                    const SizedBox(height: 30),
                    _buildSecurityInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    bool isEmail = false,
    bool isConfirmPassword = false,
    VoidCallback? toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppCores.electricBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        textInputAction: nextFocus != null
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            nextFocus.requestFocus();
          }
        },
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppCores.neonBlue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          prefixIcon: Icon(icon, color: AppCores.neonBlue),
          suffixIcon: isPassword && toggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppCores.neonBlue,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          filled: true,
          fillColor: AppCores.lightGray.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppCores.neonBlue.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppCores.neonBlue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }

          if (isEmail) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'E-mail inválido';
            }
          }

          if (isPassword && !isConfirmPassword) {
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
          }

          if (isConfirmPassword) {
            if (value != _passwordController.text) {
              return 'As senhas não coincidem';
            }
          }

          return null;
        },
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildTermosCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _aceitaTermos,
          onChanged: (value) => setState(() => _aceitaTermos = value ?? false),
          checkColor: Colors.white70,
          activeColor: AppCores.neonBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: AppCores.neonBlue, width: 2),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _aceitaTermos = !_aceitaTermos),
            child: RichText(
              text: TextSpan(
                text: 'Eu concordo com os ',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Termos de Uso',
                    style: TextStyle(
                      color: AppCores.neonBlue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' e '),
                  TextSpan(
                    text: 'Política de Privacidade ',
                    style: TextStyle(
                      color: AppCores.neonBlue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: 'da EquatorialTech',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Botão de envio do formulário
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _isLoading ? null : _handleSignup,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'CRIAR CONTA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Já tem uma conta? ',
          style: TextStyle(
            color: AppCores.neonBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Faça login',
            style: TextStyle(
              color: AppCores.neonBlue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // Informações de segurança
  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppCores.lightGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCores.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.security,
                size: 20,
                color: Colors.green,
              ), // Substituí AppCores.accentGreen se não existir
              SizedBox(width: 10),
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
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
