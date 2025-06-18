import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/utils/format_utils.dart';

void main() {
  group('FormatUtils Tests', () {
    group('Currency Formatting', () {
      test('should format currency correctly', () {
        expect(FormatUtils.formatCurrency(1234.56), equals('R\$ 1.234,56'));
        expect(FormatUtils.formatCurrency(0.0), equals('R\$ 0,00'));
        expect(FormatUtils.formatCurrency(1000000.0), equals('R\$ 1.000.000,00'));
        expect(FormatUtils.formatCurrency(0.99), equals('R\$ 0,99'));
      });

      test('should format currency from string', () {
        expect(FormatUtils.formatCurrencyFromString('123456'), equals('R\$ 1.234,56'));
        expect(FormatUtils.formatCurrencyFromString(''), equals(''));
        expect(FormatUtils.formatCurrencyFromString('abc'), equals(''));
        expect(FormatUtils.formatCurrencyFromString('123'), equals('R\$ 1,23'));
        expect(FormatUtils.formatCurrencyFromString('1'), equals('R\$ 0,01'));
      });

      test('should extract numeric value from formatted string', () {
        expect(FormatUtils.extractNumericValue('R\$ 1.234,56'), equals(1234.56));
        expect(FormatUtils.extractNumericValue('R\$ 0,00'), equals(0.0));
        expect(FormatUtils.extractNumericValue(''), equals(0.0));
        expect(FormatUtils.extractNumericValue('abc'), equals(0.0));
        expect(FormatUtils.extractNumericValue('R\$ 0,99'), equals(0.99));
      });
    });

    group('CEP Formatting', () {
      test('should format CEP correctly', () {
        expect(FormatUtils.formatCep('12345678'), equals('12345-678'));
        expect(FormatUtils.formatCep('12345-678'), equals('12345-678'));
        expect(FormatUtils.formatCep('1234567'), equals('1234567'));
        expect(FormatUtils.formatCep(''), equals(''));
        expect(FormatUtils.formatCep('abc'), equals('abc'));
      });

      test('should validate CEP correctly', () {
        expect(FormatUtils.isValidCep('12345678'), isTrue);
        expect(FormatUtils.isValidCep('12345-678'), isTrue);
        expect(FormatUtils.isValidCep('1234567'), isFalse);
        expect(FormatUtils.isValidCep(''), isFalse);
        expect(FormatUtils.isValidCep('abc'), isFalse);
      });
    });

    group('CPF Formatting', () {
      test('should format CPF correctly', () {
        expect(FormatUtils.formatCpf('12345678901'), equals('123.456.789-01'));
        expect(FormatUtils.formatCpf('123.456.789-01'), equals('123.456.789-01'));
        expect(FormatUtils.formatCpf('1234567890'), equals('1234567890'));
        expect(FormatUtils.formatCpf(''), equals(''));
        expect(FormatUtils.formatCpf('abc'), equals('abc'));
      });

      test('should validate CPF correctly', () {
        // CPF válido
        expect(FormatUtils.isValidCpf('529.982.247-25'), isTrue);
        expect(FormatUtils.isValidCpf('52998224725'), isTrue);
        
        // CPF inválido
        expect(FormatUtils.isValidCpf('12345678901'), isFalse);
        expect(FormatUtils.isValidCpf('11111111111'), isFalse);
        expect(FormatUtils.isValidCpf('1234567890'), isFalse);
        expect(FormatUtils.isValidCpf(''), isFalse);
        expect(FormatUtils.isValidCpf('abc'), isFalse);
      });
    });

    group('Phone Formatting', () {
      test('should format phone with 11 digits correctly', () {
        expect(FormatUtils.formatPhone('11987654321'), equals('(11) 98765-4321'));
        expect(FormatUtils.formatPhone('(11) 98765-4321'), equals('(11) 98765-4321'));
      });

      test('should format phone with 10 digits correctly', () {
        expect(FormatUtils.formatPhone('1187654321'), equals('(11) 8765-4321'));
        expect(FormatUtils.formatPhone('(11) 8765-4321'), equals('(11) 8765-4321'));
      });

      test('should handle invalid phone numbers', () {
        expect(FormatUtils.formatPhone('123456789'), equals('123456789'));
        expect(FormatUtils.formatPhone(''), equals(''));
        expect(FormatUtils.formatPhone('abc'), equals('abc'));
      });

      test('should validate phone correctly', () {
        expect(FormatUtils.isValidPhone('11987654321'), isTrue);
        expect(FormatUtils.isValidPhone('1187654321'), isTrue);
        expect(FormatUtils.isValidPhone('(11) 98765-4321'), isTrue);
        expect(FormatUtils.isValidPhone('123456789'), isFalse);
        expect(FormatUtils.isValidPhone(''), isFalse);
        expect(FormatUtils.isValidPhone('abc'), isFalse);
      });
    });

    group('Date Formatting', () {
      test('should format date correctly', () {
        final date = DateTime(2024, 1, 15);
        expect(FormatUtils.formatDate(date), equals('15/01/2024'));
      });

      test('should format date time correctly', () {
        final dateTime = DateTime(2024, 1, 15, 14, 30);
        expect(FormatUtils.formatDateTime(dateTime), equals('15/01/2024 14:30'));
      });

      test('should format time correctly', () {
        final time = DateTime(2024, 1, 15, 14, 30);
        expect(FormatUtils.formatTime(time), equals('14:30'));
      });

      test('should format relative date correctly', () {
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));
        final pastDate = today.subtract(const Duration(days: 5));

        expect(FormatUtils.formatRelativeDate(today), equals('Hoje'));
        expect(FormatUtils.formatRelativeDate(yesterday), equals('Ontem'));
        expect(FormatUtils.formatRelativeDate(pastDate), equals(FormatUtils.formatDate(pastDate)));
      });

      test('should format display date time correctly', () {
        final today = DateTime.now();
        final todayTime = DateTime(today.year, today.month, today.day, 14, 30);
        final pastDate = DateTime(2024, 1, 10, 14, 30);

        expect(FormatUtils.formatDisplayDateTime(todayTime), equals('Hoje às 14:30'));
        expect(FormatUtils.formatDisplayDateTime(pastDate), equals('10/01/2024 às 14:30'));
      });
    });

    group('Name Formatting', () {
      test('should format name correctly', () {
        expect(FormatUtils.formatName('joão silva'), equals('João Silva'));
        expect(FormatUtils.formatName('MARIA SANTOS'), equals('Maria Santos'));
        expect(FormatUtils.formatName('pedro'), equals('Pedro'));
        expect(FormatUtils.formatName(''), equals(''));
        expect(FormatUtils.formatName('  joão  silva  '), equals('João Silva'));
      });

      test('should handle special characters in names', () {
        expect(FormatUtils.formatName('josé-maria'), equals('José-maria'));
        expect(FormatUtils.formatName('d\'angelo'), equals('D\'angelo'));
      });
    });

    group('Email Formatting', () {
      test('should format email correctly', () {
        expect(FormatUtils.formatEmail('TEST@EXAMPLE.COM'), equals('test@example.com'));
        expect(FormatUtils.formatEmail('  test@example.com  '), equals('test@example.com'));
        expect(FormatUtils.formatEmail('Test@Example.com'), equals('test@example.com'));
      });

      test('should validate email correctly', () {
        expect(FormatUtils.isValidEmail('test@example.com'), isTrue);
        expect(FormatUtils.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(FormatUtils.isValidEmail('test@example'), isFalse);
        expect(FormatUtils.isValidEmail('@example.com'), isFalse);
        expect(FormatUtils.isValidEmail('test@'), isFalse);
        expect(FormatUtils.isValidEmail(''), isFalse);
        expect(FormatUtils.isValidEmail('abc'), isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle null-like values gracefully', () {
        expect(FormatUtils.formatCurrencyFromString(''), equals(''));
        expect(FormatUtils.extractNumericValue(''), equals(0.0));
        expect(FormatUtils.formatCep(''), equals(''));
        expect(FormatUtils.formatCpf(''), equals(''));
        expect(FormatUtils.formatPhone(''), equals(''));
        expect(FormatUtils.formatName(''), equals(''));
        expect(FormatUtils.formatEmail(''), equals(''));
      });

      test('should handle special characters', () {
        expect(FormatUtils.formatCurrencyFromString('R\$ 1.234,56'), equals('R\$ 1.234,56'));
        expect(FormatUtils.formatCep('12345-678'), equals('12345-678'));
        expect(FormatUtils.formatCpf('123.456.789-01'), equals('123.456.789-01'));
        expect(FormatUtils.formatPhone('(11) 98765-4321'), equals('(11) 98765-4321'));
      });

      test('should handle very large numbers', () {
        expect(FormatUtils.formatCurrency(999999999.99), equals('R\$ 999.999.999,99'));
        expect(FormatUtils.formatCurrencyFromString('99999999999'), equals('R\$ 999.999.999,99'));
      });

      test('should handle very small numbers', () {
        expect(FormatUtils.formatCurrency(0.01), equals('R\$ 0,01'));
        expect(FormatUtils.formatCurrencyFromString('1'), equals('R\$ 0,01'));
      });
    });
  });
} 