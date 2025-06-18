import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:DouUmHelp/Services/cep_service.dart';

import 'cep_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('CepService Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    group('consultarCep', () {
      test('should return address data for valid CEP', () async {
        // Arrange
        const cep = '12345-678';
        const expectedData = {
          'logradouro': 'Rua Teste',
          'bairro': 'Centro',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'cep': '12345-678',
        };

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"logradouro": "Rua Teste", "bairro": "Centro", "localidade": "São Paulo", "uf": "SP", "cep": "12345-678"}',
          200,
        ));

        // Act
        final result = await CepService.consultarCep(cep);

        // Assert
        expect(result, equals(expectedData));
        verify(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).called(1);
      });

      test('should handle CEP without formatting', () async {
        // Arrange
        const cep = '12345678';
        const expectedData = {
          'logradouro': 'Rua Teste',
          'bairro': 'Centro',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'cep': '12345-678',
        };

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"logradouro": "Rua Teste", "bairro": "Centro", "localidade": "São Paulo", "uf": "SP", "cep": "12345-678"}',
          200,
        ));

        // Act
        final result = await CepService.consultarCep(cep);

        // Assert
        expect(result, equals(expectedData));
      });

      test('should handle missing fields in response', () async {
        // Arrange
        const cep = '12345-678';
        const expectedData = {
          'logradouro': '',
          'bairro': '',
          'localidade': '',
          'uf': '',
          'cep': '',
        };

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"logradouro": null, "bairro": null, "localidade": null, "uf": null, "cep": null}',
          200,
        ));

        // Act
        final result = await CepService.consultarCep(cep);

        // Assert
        expect(result, equals(expectedData));
      });

      test('should throw exception for invalid CEP length', () async {
        // Arrange
        const cep = '12345';

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('CEP deve ter 8 dígitos'),
          )),
        );
      });

      test('should throw exception for CEP with too many digits', () async {
        // Arrange
        const cep = '123456789';

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('CEP deve ter 8 dígitos'),
          )),
        );
      });

      test('should throw exception when API returns error', () async {
        // Arrange
        const cep = '12345-678';

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"erro": true}',
          200,
        ));

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('CEP não encontrado'),
          )),
        );
      });

      test('should throw exception for HTTP error status', () async {
        // Arrange
        const cep = '12345-678';

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"error": "Not found"}',
          404,
        ));

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao consultar CEP'),
          )),
        );
      });

      test('should handle network errors', () async {
        // Arrange
        const cep = '12345-678';

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle malformed JSON response', () async {
        // Arrange
        const cep = '12345-678';

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          'invalid json',
          200,
        ));

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle empty response body', () async {
        // Arrange
        const cep = '12345-678';

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '',
          200,
        ));

        // Act & Assert
        expect(
          () => CepService.consultarCep(cep),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle CEP with special characters', () async {
        // Arrange
        const cep = '12345-678';
        const expectedData = {
          'logradouro': 'Rua Teste',
          'bairro': 'Centro',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'cep': '12345-678',
        };

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"logradouro": "Rua Teste", "bairro": "Centro", "localidade": "São Paulo", "uf": "SP", "cep": "12345-678"}',
          200,
        ));

        // Act
        final result = await CepService.consultarCep(cep);

        // Assert
        expect(result, equals(expectedData));
      });

      test('should handle CEP with spaces', () async {
        // Arrange
        const cep = '12345 678';
        const expectedData = {
          'logradouro': 'Rua Teste',
          'bairro': 'Centro',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'cep': '12345-678',
        };

        when(mockClient.get(
          Uri.parse('https://viacep.com.br/ws/12345678/json/'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(
          '{"logradouro": "Rua Teste", "bairro": "Centro", "localidade": "São Paulo", "uf": "SP", "cep": "12345-678"}',
          200,
        ));

        // Act
        final result = await CepService.consultarCep(cep);

        // Assert
        expect(result, equals(expectedData));
      });
    });
  });
} 