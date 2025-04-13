import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> registerService({
  required String name,
  required String lastName,
  required String phone,
  required String email,
  required String password,
  required String cpf,
  required http.Client client,
  required SharedPreferences prefs,
}) async {
  final body = {
    'name': name,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'hashpassword': password,
    'cpf': cpf,
  };

  final response = await client.post(
    Uri.parse('https://api.douumhelp.com.br/auth/register/pf'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    final token = data['token'];

    if (token != null) {
      await prefs.setString('auth_token', token);
    }

    return true;
  }

  return false;
}
