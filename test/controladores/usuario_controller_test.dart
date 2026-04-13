import 'package:flutter_test/flutter_test.dart';
import 'package:appcidadao/funcionalidades/home/controladores/usuario_controller.dart';
import 'package:appcidadao/core/repositorios/usuario_repositorio_local.dart';
import 'package:appcidadao/core/modelos/usuario.dart';

void main() {
  late UsuarioController controller;

  setUp(() {
    controller = UsuarioController(repositorio: UsuarioRepositorioLocal());
  });

  group('UsuarioController', () {
    test('inicia sem usuário carregado', () {
      expect(controller.usuario, isNull);
      expect(controller.isLoading, false);
    });

    test('getters retornam valores padrão quando sem usuário', () {
      expect(controller.nome, 'Usuário');
      expect(controller.email, 'usuario@email.com');
      //expect(controller.conta, '00000-0');
      expect(controller.avatar, '');
    });

    test('carregarUsuario carrega dados do repositório', () async {
      await controller.carregarUsuario();

      expect(controller.usuario, isNotNull);
      expect(controller.nome, isNotEmpty);
    });

    test('atualizarUsuario atualiza os dados', () async {
      await controller.carregarUsuario();

      final novoUsuario = Usuario(
        nome: 'João Atualizado',
        email: 'joao@email.com',
        conta: '12345-6',
        avatar: 'avatar_novo.jpg',
      );

      await controller.atualizarUsuario(novoUsuario);

      expect(controller.nome, 'João Atualizado');
      expect(controller.email, 'joao@email.com');
      //expect(controller.conta, '12345-6');
    });

    test('isLoading é true durante carregamento', () async {
      bool wasLoading = false;
      controller.addListener(() {
        if (controller.isLoading) wasLoading = true;
      });

      await controller.carregarUsuario();
      expect(wasLoading, true);
      expect(controller.isLoading, false);
    });
  });
}
