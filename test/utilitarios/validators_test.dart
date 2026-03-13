import 'package:flutter_test/flutter_test.dart';
import 'package:appcidadao/core/utilitarios/validators.dart';

void main() {
  group('Validators.campoObrigatorio', () {
    test('retorna erro para valor nulo', () {
      expect(Validators.campoObrigatorio(null), isNotNull);
    });

    test('retorna erro para string vazia', () {
      expect(Validators.campoObrigatorio(''), isNotNull);
    });

    test('retorna erro para string com apenas espaços', () {
      expect(Validators.campoObrigatorio('   '), isNotNull);
    });

    test('retorna null (válido) para string com conteúdo', () {
      expect(Validators.campoObrigatorio('texto'), isNull);
    });

    test('inclui nome do campo na mensagem se fornecido', () {
      final resultado = Validators.campoObrigatorio(null, 'o nome');
      expect(resultado, contains('o nome'));
    });
  });

  group('Validators.email', () {
    test('retorna erro para email vazio', () {
      expect(Validators.email(''), isNotNull);
    });

    test('retorna erro para email sem @', () {
      expect(Validators.email('emailsem.com'), isNotNull);
    });

    test('retorna erro para email sem domínio', () {
      expect(Validators.email('email@'), isNotNull);
    });

    test('retorna null para email válido', () {
      expect(Validators.email('teste@email.com'), isNull);
    });

    test('aceita email com subdomínio', () {
      expect(Validators.email('user@sub.domain.com'), isNull);
    });

    test('aceita email com +', () {
      expect(Validators.email('user+tag@email.com'), isNull);
    });
  });

  group('Validators.cpf', () {
    test('retorna erro para CPF vazio', () {
      expect(Validators.cpf(''), isNotNull);
    });

    test('retorna erro para CPF com menos de 11 dígitos', () {
      expect(Validators.cpf('123.456.789'), isNotNull);
    });

    test('retorna erro para CPF com dígitos iguais', () {
      expect(Validators.cpf('111.111.111-11'), isNotNull);
    });

    test('retorna null para CPF válido', () {
      // CPF válido de exemplo: 529.982.247-25
      expect(Validators.cpf('529.982.247-25'), isNull);
    });

    test('aceita CPF sem máscara', () {
      expect(Validators.cpf('52998224725'), isNull);
    });

    test('retorna erro para CPF com dígitos verificadores errados', () {
      expect(Validators.cpf('529.982.247-99'), isNotNull);
    });
  });

  group('Validators.cep', () {
    test('retorna erro para CEP vazio', () {
      expect(Validators.cep(''), isNotNull);
    });

    test('retorna null para CEP válido com máscara', () {
      expect(Validators.cep('65000-000'), isNull);
    });

    test('retorna null para CEP válido sem máscara', () {
      expect(Validators.cep('65000000'), isNull);
    });

    test('retorna erro para CEP incompleto', () {
      expect(Validators.cep('6500'), isNotNull);
    });
  });

  group('Validators.telefone', () {
    test('retorna erro para telefone vazio', () {
      expect(Validators.telefone(''), isNotNull);
    });

    test('retorna null para telefone fixo (10 dígitos)', () {
      expect(Validators.telefone('(98) 3232-1234'), isNull);
    });

    test('retorna null para celular (11 dígitos)', () {
      expect(Validators.telefone('(98) 99999-1234'), isNull);
    });

    test('retorna erro para número curto', () {
      expect(Validators.telefone('12345'), isNotNull);
    });
  });

  group('Validators.senha', () {
    test('retorna erro para senha vazia', () {
      expect(Validators.senha(''), isNotNull);
    });

    test('retorna erro para senha curta', () {
      expect(Validators.senha('12345'), isNotNull);
    });

    test('retorna null para senha com 6+ caracteres', () {
      expect(Validators.senha('123456'), isNull);
    });
  });

  group('Validators.confirmarSenha', () {
    test('retorna erro quando senhas não coincidem', () {
      expect(Validators.confirmarSenha('abc', '123'), isNotNull);
    });

    test('retorna null quando senhas coincidem', () {
      expect(Validators.confirmarSenha('senha123', 'senha123'), isNull);
    });

    test('retorna erro para confirmação vazia', () {
      expect(Validators.confirmarSenha('', 'senha'), isNotNull);
    });
  });
}
