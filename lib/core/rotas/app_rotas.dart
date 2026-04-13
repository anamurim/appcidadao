import 'package:flutter/material.dart';
import '../../funcionalidades/autenticacao/apresentacao/paginas/tela_login.dart';
import '../../funcionalidades/autenticacao/apresentacao/paginas/tela_cadastro_usuario.dart';
import '../../funcionalidades/autenticacao/apresentacao/paginas/tela_recuperar_senha.dart';
import '../../funcionalidades/home/apresentacao/paginas/home_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/reporte_iluminacao_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/reporte_semaforo_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/reporte_sinalizacao_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/estacionamento_irregular_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/veiculos_quebrado_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/interferencia_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/historico_reportes_pagina.dart';
import '../../funcionalidades/home/apresentacao/paginas/mapa_reportes_pagina.dart';
import '../../funcionalidades/ajustes/apresentacao/paginas/ajustes_pagina.dart';
import '../../funcionalidades/perfil/tela_perfil.dart';

/// Centralizador de rotas do App Cidadão.
///
/// Todas as rotas nomeadas são definidas como constantes aqui,
/// e o método [gerarRota] é usado como `onGenerateRoute` no MaterialApp.
class AppRotas {
  AppRotas._();

  // ── Constantes de rota ──
  static const String login = '/';
  static const String cadastro = '/signup';
  static const String recuperarSenha = '/forgot-password';
  static const String home = '/home';
  static const String reporteIluminacao = '/reporte/iluminacao';
  static const String reporteSemaforo = '/reporte/semaforo';
  static const String reporteSinalizacao = '/reporte/sinalizacao';
  static const String reporteEstacionamento = '/reporte/estacionamento';
  static const String reporteVeiculo = '/reporte/veiculo';
  static const String reporteInterferencia = '/reporte/interferencia';
  static const String historico = '/historico';
  static const String mapa = '/mapa';
  static const String ajustes = '/ajustes';
  static const String perfil = '/perfil';

  /// Gera a rota correspondente ao nome solicitado.
  ///
  /// Usado como `onGenerateRoute` no MaterialApp.
  static Route<dynamic> gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRota(const TechLoginScreen(), settings);
      case cadastro:
        return _buildRota(const SignupScreen(), settings);
      case recuperarSenha:
        return _buildRota(const ForgotPasswordScreen(), settings);
      case home:
        return _buildRota(const HomePagina(), settings);
      case reporteIluminacao:
        return _buildRota(const TelaReporteIluminacao(), settings);
      case reporteSemaforo:
        return _buildRota(const TelaReportarSemaforo(), settings);
      case reporteSinalizacao:
        return _buildRota(const TelaReporteSinalizacao(), settings);
      case reporteEstacionamento:
        return _buildRota(const TelaEstacionamentoIrregular(), settings);
      case reporteVeiculo:
        return _buildRota(const TelaVeiculoQuebrado(), settings);
      case reporteInterferencia:
        return _buildRota(const TelaReportarInterferencia(), settings);
      case historico:
        return _buildRota(const HistoricoReportesPagina(), settings);
      case mapa:
        return _buildRota(const MapaReportesPagina(), settings);
      case ajustes:
        return _buildRota(const AjustesPagina(), settings);
      case perfil:
        return _buildRota(const TelaPerfil(), settings);
      default:
        return _buildRota(
          Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _buildRota(Widget pagina, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => pagina,
      settings: settings,
    );
  }
}
