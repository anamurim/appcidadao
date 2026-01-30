import 'package:flutter/material.dart';

class DadosHome {
  static final Map<String, dynamic> userData = {
    'name': 'Flaviane Guimarães',
    'email': 'eng.flavianeguimaraes@gmail.com',
    'account': '12345-6',
  };

  static final List<Map<String, dynamic>> getfeatures = [
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
      'description': 'Falar com atendente',
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
    // Novas funcionalidades de problemas urbanos
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
      'description': 'Problemas com semáforos',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Veículo Quebrado',
      'icon': Icons.car_repair,
      'color': Color(0xFF795548),
      'description': 'Reportar veículo quebrado na via',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Estacionamento Irregular',
      'icon': Icons.local_parking,
      'color': Color(0xFF607D8B),
      'description': 'Estacionamento irregular',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Sinalização',
      'icon': Icons.signpost,
      'color': Color(0xFF009688),
      'description': 'Problemas com sinalização',
      'category': 'problemas_urbanos',
    },
    {
      'title': 'Iluminação Pública',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFFFFC107),
      'description': 'Problemas com iluminação pública',
      'category': 'problemas_urbanos',
    },
  ];

  // Lista de notificações
  //Não corrigir por enquanto. Aguardar o restante para utilizar a variável _notifications
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
