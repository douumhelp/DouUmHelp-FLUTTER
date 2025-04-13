import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'mocks.mocks.dart';
import 'package:dou_um_help_flutter/services/registerService.dart'; // ajuste o caminho

void main() {
  group('Registro API', () {
    test('deve registrar e salvar token com sucesso (201)', () async {
      final client = MockClient();
      final prefs = MockSharedPreferences();

      final fakeResponse = {
        'token': 'token_de_registro_123',
        'message': 'Usuário criado com sucesso'
      };

      when(client.post(
        Uri.parse('https://api.douumhelp.com.br/auth/register/pf'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 201));

      when(prefs.setString('auth_token', any)).thenAnswer((_) async => true);

      final result = await registerService(
        name: 'Edu',
        lastName: 'Aguiar',
        phone: '11999999999',
        email: 'edu@gmail.com',
        password: '123',
        cpf: '12345678900',
        client: client,
        prefs: prefs,
      );

      expect(result, true);
      verify(prefs.setString('auth_token', 'token_de_registro_123')).called(1);
    });
  });

  test('deve retornar false quando já existe usuário (409)', () async {
  final client = MockClient();
  final prefs = MockSharedPreferences();

  when(client.post(
    Uri.parse('https://api.douumhelp.com.br/auth/register/pf'),
    headers: anyNamed('headers'),
    body: anyNamed('body'),
  )).thenAnswer((_) async => http.Response(
    jsonEncode({'message': 'Usuário já existe'}),
    409,
  ));

  final result = await registerService(
    name: 'Edu',
    lastName: 'Aguiar',
    phone: '11999999999',
    email: 'edu@gmail.com',
    password: '123',
    cpf: '12345678900',
    client: client,
    prefs: prefs,
  );

  expect(result, false);
  verifyNever(prefs.setString('auth_token', any)); // garante que não salvou
});


}
