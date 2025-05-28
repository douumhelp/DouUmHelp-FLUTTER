import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';

class AuthService {
  static Future<bool> login(String input, String password) async {
    try {
      final isEmail = input.contains('@');
      final body = {
        if (isEmail) 'email': input else 'cpf': input.replaceAll(RegExp(r'\D'), ''),
        'hashPassword': password,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  static Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String telephone,
    required String hashPassword,
    required String cpf,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'telephone': telephone,
          'hashPassword': hashPassword,
          'cpf': cpf.replaceAll(RegExp(r'\D'), ''),
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
} 