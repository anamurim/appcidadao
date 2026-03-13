import 'package:flutter_test/flutter_test.dart';
import 'package:appcidadao/funcionalidades/home/controladores/reporte_controller.dart';
import 'package:appcidadao/core/repositorios/reporte_repositorio_local.dart';
import 'package:appcidadao/core/modelos/reporte_status.dart';
import 'package:appcidadao/funcionalidades/home/dados/modelos/reporte_interferencia.dart';

void main() {
  late ReporteController controller;

  setUp(() {
    // Usa o repositório local (in-memory) para testes
    controller = ReporteController(
      repositorio: ReporteRepositorioLocal(),
    );
  });

  group('ReporteController', () {
    test('inicia com lista vazia', () {
      expect(controller.reportes, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.errorMessage, isNull);
      expect(controller.totalReportes, 0);
    });

    test('submeterReporte adiciona reporte à lista', () async {
      final reporte = ReporteInterferencia(
        id: '1',
        endereco: 'Rua Teste, 123',
        descricao: 'Teste de reporte',
        tipoInterferencia: 'Buraco na Via',
      );

      final result = await controller.submeterReporte(reporte);

      expect(result, true);
      expect(controller.totalReportes, 1);
      expect(controller.reportes.first.id, '1');
    });

    test('carregarReportes carrega do repositório', () async {
      // Primeiro submete
      await controller.submeterReporte(
        ReporteInterferencia(
          id: '1',
          endereco: 'Rua A',
          descricao: 'Desc A',
          tipoInterferencia: 'Buraco',
        ),
      );

      // Cria outro controller com o mesmo repositório singleton
      final outroController = ReporteController(
        repositorio: ReporteRepositorioLocal(),
      );
      await outroController.carregarReportes();

      expect(outroController.reportes, isNotEmpty);
    });

    test('atualizarStatus muda o status do reporte', () async {
      await controller.submeterReporte(
        ReporteInterferencia(
          id: '2',
          endereco: 'Rua B',
          descricao: 'Desc B',
          tipoInterferencia: 'Lixo',
        ),
      );

      await controller.atualizarStatus('2', ReporteStatus.emAnalise);

      expect(
        controller.reportes.firstWhere((r) => r.id == '2').status,
        ReporteStatus.emAnalise,
      );
    });

    test('removerReporte remove o reporte da lista', () async {
      await controller.submeterReporte(
        ReporteInterferencia(
          id: '3',
          endereco: 'Rua C',
          descricao: 'Desc C',
          tipoInterferencia: 'Árvore',
        ),
      );

      expect(controller.totalReportes, greaterThanOrEqualTo(1));

      await controller.removerReporte('3');

      expect(
        controller.reportes.where((r) => r.id == '3'),
        isEmpty,
      );
    });

    test('isLoading é true durante carregamento', () async {
      bool wasLoading = false;
      controller.addListener(() {
        if (controller.isLoading) wasLoading = true;
      });

      await controller.carregarReportes();
      expect(wasLoading, true);
      expect(controller.isLoading, false);
    });
  });
}
