import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  static Future<Map<String, dynamic>?> consultarCep(String cep) async {
    try {
      // Remove caracteres não numéricos
      final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
      
      if (cepLimpo.length != 8) {
        throw Exception('CEP deve ter 8 dígitos');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/$cepLimpo/json/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Verifica se a API retornou erro
        if (data['erro'] == true) {
          throw Exception('CEP não encontrado');
        }

        return {
          'logradouro': data['logradouro'] ?? '',
          'bairro': data['bairro'] ?? '',
          'localidade': data['localidade'] ?? '',
          'uf': data['uf'] ?? '',
          'cep': data['cep'] ?? '',
        };
      } else {
        throw Exception('Erro ao consultar CEP');
      }
    } catch (e) {
      print('Erro na consulta do CEP: $e');
      rethrow;
    }
  }
} 