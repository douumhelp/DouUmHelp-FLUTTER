import 'package:intl/intl.dart';

class FormatUtils {
  // Formatação de moeda brasileira
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // Formatação de moeda a partir de string (para inputs)
  static String formatCurrencyFromString(String value) {
    if (value.isEmpty) return '';
    
    // Remove tudo que não é número
    final numero = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numero.isEmpty) return '';
    
    // Converte para número e divide por 100 para obter o valor em reais
    final valorEmReais = (double.parse(numero) / 100).toStringAsFixed(2);
    
    // Formata com R$ e vírgula
    return 'R\$ ${valorEmReais.replaceAll('.', ',')}';
  }

  // Extrair valor numérico de string formatada
  static double extractNumericValue(String formattedValue) {
    final numero = formattedValue.replaceAll(RegExp(r'[^\d]'), '');
    return numero.isEmpty ? 0 : double.parse(numero) / 100;
  }

  // Formatação de CEP (00000-000)
  static String formatCep(String cep) {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length == 8) {
      return '${cepLimpo.substring(0, 5)}-${cepLimpo.substring(5)}';
    }
    return cep;
  }

  // Formatação de CPF (000.000.000-00)
  static String formatCpf(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (cpfLimpo.length == 11) {
      return '${cpfLimpo.substring(0, 3)}.${cpfLimpo.substring(3, 6)}.${cpfLimpo.substring(6, 9)}-${cpfLimpo.substring(9)}';
    }
    return cpf;
  }

  // Formatação de telefone ((00) 00000-0000)
  static String formatPhone(String phone) {
    final phoneLimpo = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (phoneLimpo.length == 11) {
      return '(${phoneLimpo.substring(0, 2)}) ${phoneLimpo.substring(2, 7)}-${phoneLimpo.substring(7)}';
    } else if (phoneLimpo.length == 10) {
      return '(${phoneLimpo.substring(0, 2)}) ${phoneLimpo.substring(2, 6)}-${phoneLimpo.substring(6)}';
    }
    return phone;
  }

  // Formatação de data (dd/MM/yyyy)
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Formatação de data e hora (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  // Formatação de hora (HH:mm)
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Formatação de data relativa (Hoje, Ontem, etc.)
  static String formatRelativeDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (date.year == today.year && 
        date.month == today.month && 
        date.day == today.day) {
      return 'Hoje';
    } else if (date.year == yesterday.year && 
               date.month == yesterday.month && 
               date.day == yesterday.day) {
      return 'Ontem';
    } else {
      return formatDate(date);
    }
  }

  // Formatação de data e hora para exibição
  static String formatDisplayDateTime(DateTime dateTime) {
    final today = DateTime.now();
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    
    if (dateOnly == todayOnly) {
      return 'Hoje às ${formatTime(dateTime)}';
    } else {
      return '${formatDate(dateTime)} às ${formatTime(dateTime)}';
    }
  }

  // Formatação de nome (primeira letra maiúscula)
  static String formatName(String name) {
    if (name.isEmpty) return name;
    return name.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Formatação de email (lowercase)
  static String formatEmail(String email) {
    return email.trim().toLowerCase();
  }

  // Validação de email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validação de CPF
  static bool isValidCpf(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (cpfLimpo.length != 11) return false;
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfLimpo)) return false;
    
    // Validação dos dígitos verificadores
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpfLimpo[i]) * (10 - i);
    }
    int remainder = sum % 11;
    int digit1 = remainder < 2 ? 0 : 11 - remainder;
    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpfLimpo[i]) * (11 - i);
    }
    remainder = sum % 11;
    int digit2 = remainder < 2 ? 0 : 11 - remainder;
    
    return cpfLimpo[9] == digit1.toString() && cpfLimpo[10] == digit2.toString();
  }

  // Validação de CEP
  static bool isValidCep(String cep) {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    return cepLimpo.length == 8;
  }

  // Validação de telefone
  static bool isValidPhone(String phone) {
    final phoneLimpo = phone.replaceAll(RegExp(r'[^\d]'), '');
    return phoneLimpo.length >= 10 && phoneLimpo.length <= 11;
  }
} 