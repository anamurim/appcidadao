import 'package:flutter/material.dart';
import '../../../../../core/constantes/cores.dart'; // Importando suas cores padrões

class TelaNotificacoesAplicativo extends StatefulWidget {
  const TelaNotificacoesAplicativo({super.key});

  @override
  State<TelaNotificacoesAplicativo> createState() =>
      _TelaNotificacoesAplicativosState();
}

class _TelaNotificacoesAplicativosState
    extends State<TelaNotificacoesAplicativo> {
  // Estados para os diferentes tipos de alertas
  bool _alertasGerais = true;
  bool _notificacoesEmail = false;
  bool _notificacoesSMS = true;
  bool _alertasSeguranca = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCores
            .deepBlue, // Consistência com configuracoes.dart e seguranca_pagina.dart
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: AppCores.techGray, // Fundo padrão do seu app
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecao('Alertas do Sistema'),

            _buildSwitchCard(
              icon: Icons.notifications_active_outlined,
              titulo: 'Alertas Gerais',
              subtitulo: 'Receba avisos sobre novidades e atualizações',
              valor: _alertasGerais,
              onChanged: (bool value) {
                setState(() => _alertasGerais = value);
              },
            ),

            _buildSwitchCard(
              icon: Icons.security_outlined,
              titulo: 'Segurança',
              subtitulo: 'Alertas sobre logins em novos dispositivos',
              valor: _alertasSeguranca,
              onChanged: (bool value) {
                setState(() => _alertasSeguranca = value);
              },
            ),

            const SizedBox(height: 24),
            _buildSecao('Canais de Comunicação'),

            _buildSwitchCard(
              icon: Icons.alternate_email_rounded,
              titulo: 'E-mail',
              subtitulo: 'Receba resumos semanais no seu e-mail',
              valor: _notificacoesEmail,
              onChanged: (bool value) {
                setState(() => _notificacoesEmail = value);
              },
            ),

            _buildSwitchCard(
              icon: Icons.sms_outlined,
              titulo: 'SMS',
              subtitulo: 'Alertas críticos via mensagem de texto',
              valor: _notificacoesSMS,
              onChanged: (bool value) {
                setState(() => _notificacoesSMS = value);
              },
            ),

            const SizedBox(height: 32),

            // Botão para resetar preferências
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppCores.neonBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Lógica para restaurar padrão de fábrica
                },
                child: const Text(
                  'Restaurar padrões',
                  style: TextStyle(
                    color: AppCores.neonBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Segue o padrão de seção que você usa no configuracoes.dart
  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Widget customizado baseado no seu _buildCardConfig
  Widget _buildSwitchCard({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppCores.electricBlue),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitulo, style: const TextStyle(fontSize: 13)),
        trailing: Switch(
          activeThumbColor: AppCores
              .neonBlue, // Corrigido conforme a nova versão do Flutter que você usa
          value: valor,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
