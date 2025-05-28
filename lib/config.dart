class ApiConfig {
  // URL base da API
  static const String baseUrl = 'https://api-production-d036.up.railway.app';  // Substitua com sua URL real
  
  // Você pode adicionar outros endpoints específicos aqui
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get registerEndpoint => '$baseUrl/auth/register/pf';
  static String get categories => '$baseUrl/categories';
  static String get usersEndpoint => '$baseUrl/users';
  // Adicione mais endpoints conforme necessário
} 