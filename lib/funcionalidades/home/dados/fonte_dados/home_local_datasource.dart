import 'package:flutter/material.dart';
import '../../../perfil/dominio/entidades/usuario.dart';

class DadosHome {
  // Dados do usuário (modelo tipado)
  static final Usuario usuario = const Usuario(
    nome: 'Usuário',
    email: 'e-mail@gmail.com',
    conta: '12345-6',
    avatar:
        'https://ui-avatars.com/api/?name=Carlos+Silva&background=0066FF&color=fff',
  );

  // Compatibilidade: mantém acesso via Map para widgets existentes
  static Map<String, dynamic> get userData => {
    'name': usuario.nome,
    'email': usuario.email,
    'account': usuario.conta,
    'avatar': usuario.avatar,
  };

  //Lista de funcionalidades principais
  static final List<Map<String, dynamic>> getfuncionalidades = [
    {
      'title': 'Minha Conta',
      'icon': Icons.account_balance_wallet,
      'color': const Color(0xFF0066FF),
      'description': 'Verificar saldo e faturas',
    },
    {
      'title': 'Consumo',
      'icon': Icons.show_chart,
      'color': Color(0xFF00BFFF),
      'description': 'Monitorar consumo de energia',
    },
    {
      'title': 'Pagamentos',
      'icon': Icons.payment,
      'color': Color(0xFF00FF88),
      'description': 'Pagar contas e agendar',
    },
    {
      'title': 'Suporte',
      'icon': Icons.support_agent,
      'color': Color(0xFFFF6B6B),
      'description': 'Entrar em contato com o suporte',
    },
    {
      'title': 'Falta de Energia',
      'icon': Icons.power_off,
      'color': Color(0xFFFFA726),
      'description': 'Reportar problemas',
    },
    {
      'title': 'Economia',
      'icon': Icons.eco,
      'color': Color(0xFF4CAF50),
      'description': 'Dicas para economizar',
    },
    {
      'title': 'Interferência na Via',
      'icon': Icons.traffic,
      'color': Color(0xFF9C27B0),
      'description': 'Reportar interferências na via pública',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Semáforo',
      'icon': Icons.traffic_outlined,
      'color': Color(0xFFFF9800),
      'description': 'Reportar problemas com semáforos',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Veículo Quebrado',
      'icon': Icons.car_repair,
      'color': Color(0xFFFF4081),
      'description': 'Reportar veículo quebrado na via',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Estacionamento Irregular',
      'icon': Icons.local_parking,
      'color': Color(0xFF607D8B),
      'description': 'Reportar estacionamento irregular',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Sinalização',
      'icon': Icons.signpost,
      'color': Color(0xFF009688),
      'description': 'Reportar problemas com sinalização',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Iluminação Pública',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFFFFC107),
      'description': 'Reportar problemas com iluminação pública',
      'category': 'problemas_urbanos',
    },
  ];

  // Lista de notificações
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Fatura disponível',
      'message': 'Sua fatura de janeiro está disponível para pagamento.',
      'time': 'Há 2 dias',
      'read': false,
    },

    {
      'id': 2,
      'title': 'Manutenção Programada',
      'message': 'Haverá manutenção na rede elétrica do seu bairro amanhã.',
      'time': 'Há 5 horas',
      'read': false,
    },
    {
      'id': 3,
      'title': 'Dica de Economia',
      'message': 'Ar-condicionado em 23°C economiza até 20% de energia.',
      'time': 'Ontem',
      'read': true,
    },
  ];

  // Retorna a quantidade de itens não lidos
  static int get unreadCount => notifications.where((n) => !n['read']).length;

  // Simula marcar como lida
  static void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) notifications[index]['read'] = true;
  }
}
