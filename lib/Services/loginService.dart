import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loginService({
  required String input,
  required String password,
  required http.Client client,
  required SharedPreferences prefs,
}) async {
  final isEmail = input.contains('@');
  final body = {
    if (isEmail) 'email': input else 'cpf': input.replaceAll(RegExp(r'\D'), ''),
    'hashPassword': password,
    
  };

  print('Enviando login com corpo: $body');

  final response = await client.post(
    Uri.parse('https://api.douumhelp.com.br/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  print('STATUS: ${response.statusCode}');
  print('BODY: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    final token = data['token'];

    if (token != null) {
      await prefs.setString('auth_token', token);
      return true;
    }
  }

  return false;
}
