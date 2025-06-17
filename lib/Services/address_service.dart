import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/endereco.dart';
import 'auth_service.dart';

class AddressService {
  static const String baseEndpoint = ApiConfig.addresses;

  // Buscar todos os endereços do usuário
  static Future<List<Endereco>> getAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      print('=== GET ADDRESSES ===');
      print('URL: $baseEndpoint');
      print('Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse(baseEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Endereco.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar endereços: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no getAddresses: $e');
      rethrow;
    }
  }

  // Criar novo endereço
  static Future<Endereco> createAddress(Endereco endereco) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      // Verificar se o token não está vazio
      if (token.trim().isEmpty) {
        throw Exception('Token inválido');
      }

      // Preparar dados para envio - remover campos nulos e validar
      final requestBody = await _prepareAddressData(endereco);
      
      print('=== CREATE ADDRESS ===');
      print('URL: $baseEndpoint');
      print('Token: ${token.substring(0, 20)}...');
      print('Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(baseEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('=== CREATE RESPONSE DEBUG ===');
        print('Response data: $data');
        print('Response data type: ${data.runtimeType}');
        if (data is Map<String, dynamic>) {
          print('Response keys: ${data.keys.toList()}');
          print('User ID in response: ${data['userId']} (type: ${data['userId']?.runtimeType})');
        }
        return Endereco.fromJson(data);
      } else {
        throw Exception('Erro ao criar endereço: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no createAddress: $e');
      rethrow;
    }
  }

  // Atualizar endereço
  static Future<Endereco> updateAddress(String id, Endereco endereco) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      // Preparar dados para envio - remover campos nulos e validar
      final requestBody = await _prepareAddressData(endereco);
      
      print('=== UPDATE ADDRESS ===');
      print('URL: $baseEndpoint/$id');
      print('Token: ${token.substring(0, 20)}...');
      print('Request Body: $requestBody');

      final response = await http.put(
        Uri.parse('$baseEndpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Endereco.fromJson(data);
      } else {
        throw Exception('Erro ao atualizar endereço: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no updateAddress: $e');
      rethrow;
    }
  }

  // Deletar endereço
  static Future<void> deleteAddress(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      print('=== DELETE ADDRESS ===');
      print('URL: $baseEndpoint/$id');
      print('Token: ${token.substring(0, 20)}...');

      final response = await http.delete(
        Uri.parse('$baseEndpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar endereço: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no deleteAddress: $e');
      rethrow;
    }
  }

  // Método de teste para verificar se a API está funcionando
  static Future<bool> testApiConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print('Token não encontrado');
        return false;
      }

      print('=== TESTING API CONNECTION ===');
      print('URL: $baseEndpoint');
      print('Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse(baseEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      print('Erro no teste de conexão: $e');
      return false;
    }
  }

  // Método auxiliar para preparar dados do endereço
  static Future<Map<String, dynamic>> _prepareAddressData(Endereco endereco) async {
    // Obter ID do usuário do JWT
    final userId = await AuthService.getUserId();
    
    // Formatar CEP (remover caracteres não numéricos)
    final cep = endereco.cep.replaceAll(RegExp(r'[^\d]'), '');
    
    // Validar CEP
    if (cep.length != 8) {
      throw Exception('CEP deve ter 8 dígitos. CEP fornecido: $cep (${cep.length} dígitos)');
    }
    
    // Formatar estado (apenas 2 caracteres)
    final estado = endereco.state.trim().toUpperCase();
    String estadoFormatado;
    
    // Mapear estados completos para siglas
    switch (estado.toLowerCase()) {
      case 'parana':
      case 'paraná':
        estadoFormatado = 'PR';
        break;
      case 'sao paulo':
      case 'são paulo':
        estadoFormatado = 'SP';
        break;
      case 'rio de janeiro':
        estadoFormatado = 'RJ';
        break;
      case 'minas gerais':
        estadoFormatado = 'MG';
        break;
      case 'bahia':
        estadoFormatado = 'BA';
        break;
      case 'pernambuco':
        estadoFormatado = 'PE';
        break;
      case 'ceara':
      case 'ceará':
        estadoFormatado = 'CE';
        break;
      case 'maranhao':
      case 'maranhão':
        estadoFormatado = 'MA';
        break;
      case 'goias':
      case 'goiás':
        estadoFormatado = 'GO';
        break;
      case 'pará':
      case 'para':
        estadoFormatado = 'PA';
        break;
      case 'amazonas':
        estadoFormatado = 'AM';
        break;
      case 'mato grosso':
        estadoFormatado = 'MT';
        break;
      case 'mato grosso do sul':
        estadoFormatado = 'MS';
        break;
      case 'rio grande do sul':
        estadoFormatado = 'RS';
        break;
      case 'santa catarina':
        estadoFormatado = 'SC';
        break;
      case 'espirito santo':
      case 'espírito santo':
        estadoFormatado = 'ES';
        break;
      case 'rio grande do norte':
        estadoFormatado = 'RN';
        break;
      case 'alagoas':
        estadoFormatado = 'AL';
        break;
      case 'piaui':
      case 'piauí':
        estadoFormatado = 'PI';
        break;
      case 'distrito federal':
        estadoFormatado = 'DF';
        break;
      case 'sergipe':
        estadoFormatado = 'SE';
        break;
      case 'roraima':
        estadoFormatado = 'RR';
        break;
      case 'tocantins':
        estadoFormatado = 'TO';
        break;
      case 'amapa':
      case 'amapá':
        estadoFormatado = 'AP';
        break;
      case 'acre':
        estadoFormatado = 'AC';
        break;
      case 'rondonia':
      case 'rondônia':
        estadoFormatado = 'RO';
        break;
      default:
        // Se já for uma sigla de 2 caracteres, usar como está
        estadoFormatado = estado.length == 2 ? estado : estado.substring(0, 2);
    }
    
    final data = <String, dynamic>{
      'cep': cep,
      'addressLine': endereco.addressLine.trim(),
      'addressNumber': endereco.addressNumber.trim(),
      'city': endereco.city.trim(),
      'state': estadoFormatado,
      'latitude': endereco.latitude,
      'longitude': endereco.longitude,
    };

    // Adicionar neighborhood apenas se não for nulo ou vazio
    if (endereco.neighborhood != null && endereco.neighborhood!.trim().isNotEmpty) {
      data['neighborhood'] = endereco.neighborhood!.trim();
    }

    // Adicionar label apenas se não for nulo ou vazio
    if (endereco.label != null && endereco.label!.trim().isNotEmpty) {
      data['label'] = endereco.label!.trim();
    }

    // Adicionar userId se disponível
    if (userId != null) {
      print('=== USER ID DEBUG ===');
      print('User ID type: ${userId.runtimeType}');
      print('User ID value: $userId');
      data['userId'] = userId;
    } else {
      print('=== USER ID DEBUG ===');
      print('User ID is null');
    }

    // Adicionar ID apenas se não for nulo (para updates)
    if (endereco.id != null) {
      data['id'] = endereco.id;
    }

    print('=== PREPARED DATA ===');
    print('Original state: ${endereco.state}');
    print('Formatted state: $estadoFormatado');
    print('Original CEP: ${endereco.cep}');
    print('Formatted CEP: $cep');
    print('User ID: $userId');
    print('Data to send: $data');

    return data;
  }

  // Buscar endereço por ID
  static Future<Endereco?> getAddressById(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      print('=== GET ADDRESS BY ID ===');
      print('URL: $baseEndpoint/$id');
      print('Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseEndpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Endereco.fromJson(data);
      } else if (response.statusCode == 404) {
        print('Endereço não encontrado');
        return null;
      } else {
        throw Exception('Erro ao buscar endereço: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no getAddressById: $e');
      rethrow;
    }
  }
} 