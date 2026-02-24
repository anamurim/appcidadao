import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart';
import '../../../ajustes/apresentacao/paginas/alterar_senha_pagina.dart';
import '../../../ajustes/apresentacao/paginas/dispositivos_conectados_pagina.dart';

class TelaSeguranca extends StatefulWidget {
  const TelaSeguranca({super.key});

  @override
  State<TelaSeguranca> createState() => _TelaSegurancaState();
}

class _TelaSegurancaState extends State<TelaSeguranca> {
  bool _biometriaAtiva = true;
  bool _autenticacaoDoisFatores = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes de segurança',
          style: TextStyle(color: Colors.white),
        ),
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: AppCores.neonBlue),
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao('Acesso'),

            _buildCardConfig(
              icon: Icons.password_rounded,
              titulo: 'Alterar Senha',
              subtitulo: 'Atualize sua senha de acesso periodicamente',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaAlterarSenha(),
                  ),
                );
              },
            ),

            _buildCardConfig(
              icon: Icons.fingerprint_rounded,
              titulo: 'Biometria',
              subtitulo: 'Acessar o app usando digital ou rosto',
              trailing: Switch(
                activeThumbColor: AppCores.neonBlue,
                value: _biometriaAtiva,
                onChanged: (bool value) {
                  setState(() {
                    _biometriaAtiva = value;
                  });
                },
              ),
              onTap: () {},
            ),

            const SizedBox(height: 24),
            _buildSecao('Privacidade e Verificação'),

            _buildCardConfig(
              icon: Icons.verified_user_outlined,
              titulo: 'Autenticação dois fatores',
              subtitulo: 'Um código extra será solicitado no login',
              trailing: Switch(
                // 🔹 Correção: 'activeThumbColor' em vez de 'activeColor'
                activeThumbColor: AppCores.neonBlue,
                value: _autenticacaoDoisFatores,
                onChanged: (bool value) {
                  setState(() {
                    _autenticacaoDoisFatores = value;
                  });
                },
              ),
              onTap: () {},
            ),

            _buildCardConfig(
              icon: Icons.devices_other_rounded,
              titulo: 'Dispositivos Conectados',
              subtitulo: 'Gerencie onde sua conta está aberta',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaDispositivosConectados(),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Desativar minha conta',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardConfig({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppCores.neonBlue),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitulo),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
