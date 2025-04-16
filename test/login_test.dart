import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dou_um_help_flutter/Services/loginService.dart';

import 'mocks.mocks.dart';

void main() {
  group('Login API', () {
    
    test('deve salvar token ao receber status 201', () async {

      
      final client = MockClient();
      final prefs = MockSharedPreferences();

      final fakeResponse = {
        'token': 'fake_token_123',
        'message': 'Login realizado com sucesso!'
      };

      when(client.post(
        Uri.parse('https://api.douumhelp.com.br/auth/login'),
        headers: anyNamed('headers'),
        body: jsonEncode({
          'email': 'teste@email.com',
          'hashPassword': '123',
        }),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 201));

      when(prefs.setString('auth_token', any))
          .thenAnswer((_) async => true);

          final result = await loginService(
            input: 'teste@email.com',
            password: '123',
            client: client,
            prefs: prefs,
          );


      verify(prefs.setString('auth_token', 'fake_token_123')).called(1);
    });
  });

  test('deve retornar false ao receber status 401 (login inválido)', () async {
  final client = MockClient();
  final prefs = MockSharedPreferences();

  when(client.post(
    Uri.parse('https://api.douumhelp.com.br/auth/login'),
    headers: anyNamed('headers'),
    body: jsonEncode({
      'email': 'usuario_invalido@email.com',
      'hashPassword': 'senha_errada',
    }),
  )).thenAnswer((_) async => http.Response('{"message": "Usuário não encontrado"}', 401));

  final result = await loginService(
    input: 'usuario_invalido@email.com',
    password: 'senha_errada',
    client: client,
    prefs: prefs,
  );

  expect(result, false);
  verifyNever(prefs.setString('auth_token', any)); 
});

}

