import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../utils/config.dart';

class AuthService {
  // Função para testar se a API está online
  static Future<bool> testApiConnection() async {
    try {
      print('=== TESTANDO CONEXÃO COM API ===');
      print('URL: ${ApiConfig.baseUrl}');
      
      final response = await http.get(Uri.parse(ApiConfig.baseUrl));
      
      print('Status code: ${response.statusCode}');
      print('Response: ${response.body}');
      
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      print('Erro ao conectar com API: $e');
      return false;
    }
  }

  static Future<bool> login(String input, String password) async {
    try {
      final isEmail = input.contains('@');
      final body = {
        if (isEmail) 'email': input else 'cpf': input.replaceAll(RegExp(r'\D'), ''),
        'hashPassword': password,
        if (isEmail) 'role': 'pf',
      };

      print('=== DEBUG LOGIN ===');
      print('Input original: $input');
      print('É email? $isEmail');
      print('Password: $password');
      print('Body enviado: $body');
      print('URL: ${ApiConfig.loginEndpoint}');

      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Status code do login: ${response.statusCode}');
      print('Response body do login: ${response.body}');
      print('Headers da resposta: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          print('Token salvo com sucesso: $token');
          return true;
        } else {
          print('Token não encontrado na resposta');
        }
      } else {
        print('Login falhou - status: ${response.statusCode}');
        print('Mensagem de erro: ${response.body}');
      }
      return false;
    } catch (e) {
      print('Erro no login: $e');
      print('Stack trace: ${StackTrace.current}');
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
          'role': 'pf',
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

  // Função para obter o ID do usuário do JWT token
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        final decodedToken = JwtDecoder.decode(token);
        print('=== JWT DECODED ===');
        print('Token completo: $decodedToken');
        print('Campos disponíveis: ${decodedToken.keys.toList()}');
        
        // Tentar obter o ID do usuário do campo 'user'
        final userData = decodedToken['user'];
        if (userData != null && userData is Map<String, dynamic>) {
          final userId = userData['id'];
          print('User ID encontrado no campo user: $userId');
          
          if (userId != null && userId is String) {
            print('User ID retornado como string: $userId');
            return userId;
          }
        }
        
        // Fallback: tentar diferentes campos possíveis para o ID do usuário
        final userId = decodedToken['sub'] ?? 
                      decodedToken['userId'] ?? 
                      decodedToken['user_id'] ?? 
                      decodedToken['id'] ??
                      decodedToken['user'];
        
        print('User ID encontrado (fallback): $userId');
        
        if (userId != null && userId is String) {
          print('User ID retornado como string (fallback): $userId');
          return userId;
        }
      }
      print('Nenhum User ID encontrado no token');
      return null;
    } catch (e) {
      print('Erro ao obter ID do usuário: $e');
      return null;
    }
  }
} 