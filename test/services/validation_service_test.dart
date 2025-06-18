import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/Services/validation_service.dart';

void main() {
  group('ValidationService Tests', () {
    group('Price Validation', () {
      test('should validate price range correctly', () {
        expect(ValidationService.isValidPriceRange(10.0, 50.0), isTrue);
        expect(ValidationService.isValidPriceRange(0.0, 50.0), isFalse);
        expect(ValidationService.isValidPriceRange(50.0, 10.0), isFalse);
        expect(ValidationService.isValidPriceRange(0.0, 0.0), isFalse);
        expect(ValidationService.isValidPriceRange(-10.0, 50.0), isFalse);
      });

      test('should validate price correctly', () {
        expect(ValidationService.isValidPrice(10.0), isTrue);
        expect(ValidationService.isValidPrice(0.01), isTrue);
        expect(ValidationService.isValidPrice(0.0), isFalse);
        expect(ValidationService.isValidPrice(-10.0), isFalse);
      });

      test('should validate currency value correctly', () {
        expect(ValidationService.isValidCurrencyValue('R\$ 10,00'), isTrue);
        expect(ValidationService.isValidCurrencyValue('R\$ 0,01'), isTrue);
        expect(ValidationService.isValidCurrencyValue('R\$ 0,00'), isFalse);
        expect(ValidationService.isValidCurrencyValue(''), isFalse);
        expect(ValidationService.isValidCurrencyValue('abc'), isFalse);
      });
    });

    group('Solicitacao Form Validation', () {
      test('should validate complete form successfully', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, isNull);
      });

      test('should fail validation with missing category', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: null,
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, equals('Selecione uma categoria'));
      });

      test('should fail validation with empty category', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: '',
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, equals('Selecione uma categoria'));
      });

      test('should fail validation with missing address', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: null,
          description: 'Test service description',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, equals('Selecione um endereço'));
      });

      test('should fail validation with empty description', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: '',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, equals('Descreva o serviço'));
      });

      test('should fail validation with whitespace description', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: '   ',
          hasValueRange: true,
          minValue: 10.0,
          maxValue: 50.0,
        );

        expect(result, equals('Descreva o serviço'));
      });

      test('should fail validation with invalid price range', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: true,
          minValue: 50.0,
          maxValue: 10.0,
        );

        expect(result, equals('O valor mínimo deve ser menor que o valor máximo'));
      });

      test('should fail validation with zero values', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: true,
          minValue: 0.0,
          maxValue: 50.0,
        );

        expect(result, equals('O valor mínimo deve ser menor que o valor máximo'));
      });

      test('should pass validation without value range', () {
        final result = ValidationService.validateSolicitacaoForm(
          categoryId: 'cat1',
          addressId: 'addr1',
          description: 'Test service description',
          hasValueRange: false,
          minValue: 0.0,
          maxValue: 0.0,
        );

        expect(result, isNull);
      });
    });

    group('Address Form Validation', () {
      test('should validate complete address form successfully', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345-678',
          addressLine: 'Rua Teste',
          addressNumber: '123',
          city: 'São Paulo',
          state: 'SP',
        );

        expect(result, isNull);
      });

      test('should fail validation with missing CEP', () {
        final result = ValidationService.validateAddressForm(
          cep: '',
          addressLine: 'Rua Teste',
          addressNumber: '123',
          city: 'São Paulo',
          state: 'SP',
        );

        expect(result, equals('CEP é obrigatório'));
      });

      test('should fail validation with invalid CEP', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345',
          addressLine: 'Rua Teste',
          addressNumber: '123',
          city: 'São Paulo',
          state: 'SP',
        );

        expect(result, equals('CEP inválido'));
      });

      test('should fail validation with missing address line', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345-678',
          addressLine: '',
          addressNumber: '123',
          city: 'São Paulo',
          state: 'SP',
        );

        expect(result, equals('Endereço é obrigatório'));
      });

      test('should fail validation with missing address number', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345-678',
          addressLine: 'Rua Teste',
          addressNumber: '',
          city: 'São Paulo',
          state: 'SP',
        );

        expect(result, equals('Número é obrigatório'));
      });

      test('should fail validation with missing city', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345-678',
          addressLine: 'Rua Teste',
          addressNumber: '123',
          city: '',
          state: 'SP',
        );

        expect(result, equals('Cidade é obrigatória'));
      });

      test('should fail validation with missing state', () {
        final result = ValidationService.validateAddressForm(
          cep: '12345-678',
          addressLine: 'Rua Teste',
          addressNumber: '123',
          city: 'São Paulo',
          state: '',
        );

        expect(result, equals('Estado é obrigatório'));
      });
    });

    group('Register Form Validation', () {
      test('should validate complete register form successfully', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, isNull);
      });

      test('should fail validation with missing name', () {
        final result = ValidationService.validateRegisterForm(
          name: '',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('Nome é obrigatório'));
      });

      test('should fail validation with single name', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('Digite nome completo'));
      });

      test('should fail validation with missing CPF', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('CPF é obrigatório'));
      });

      test('should fail validation with invalid CPF', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '12345678901',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('CPF inválido'));
      });

      test('should fail validation with missing email', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: '',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('Email é obrigatório'));
      });

      test('should fail validation with invalid email', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: 'invalid-email',
          password: 'password123',
          confirmPassword: 'password123',
        );

        expect(result, equals('Email inválido'));
      });

      test('should fail validation with missing password', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: '',
          confirmPassword: 'password123',
        );

        expect(result, equals('Senha é obrigatória'));
      });

      test('should fail validation with short password', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: '12345',
          confirmPassword: '12345',
        );

        expect(result, equals('Senha deve ter pelo menos 6 caracteres'));
      });

      test('should fail validation with mismatched passwords', () {
        final result = ValidationService.validateRegisterForm(
          name: 'João Silva',
          cpf: '529.982.247-25',
          email: 'joao@example.com',
          password: 'password123',
          confirmPassword: 'password456',
        );

        expect(result, equals('Senhas não coincidem'));
      });
    });

    group('Login Form Validation', () {
      test('should validate complete login form successfully', () {
        final result = ValidationService.validateLoginForm(
          email: 'joao@example.com',
          password: 'password123',
        );

        expect(result, isNull);
      });

      test('should fail validation with missing email', () {
        final result = ValidationService.validateLoginForm(
          email: '',
          password: 'password123',
        );

        expect(result, equals('Email é obrigatório'));
      });

      test('should fail validation with invalid email', () {
        final result = ValidationService.validateLoginForm(
          email: 'invalid-email',
          password: 'password123',
        );

        expect(result, equals('Email inválido'));
      });

      test('should fail validation with missing password', () {
        final result = ValidationService.validateLoginForm(
          email: 'joao@example.com',
          password: '',
        );

        expect(result, equals('Senha é obrigatória'));
      });
    });

    group('DateTime Validation', () {
      test('should validate future date time', () {
        final futureDateTime = DateTime.now().add(const Duration(hours: 1));
        expect(ValidationService.isValidScheduledDateTime(futureDateTime), isTrue);
        expect(ValidationService.validateScheduledDateTime(futureDateTime), isNull);
      });

      test('should fail validation with past date time', () {
        final pastDateTime = DateTime.now().subtract(const Duration(hours: 1));
        expect(ValidationService.isValidScheduledDateTime(pastDateTime), isFalse);
        expect(ValidationService.validateScheduledDateTime(pastDateTime), equals('Data e hora devem ser futuras'));
      });

      test('should fail validation with current date time', () {
        final currentDateTime = DateTime.now();
        expect(ValidationService.isValidScheduledDateTime(currentDateTime), isFalse);
        expect(ValidationService.validateScheduledDateTime(currentDateTime), equals('Data e hora devem ser futuras'));
      });
    });

    group('Description Validation', () {
      test('should validate good description', () {
        final result = ValidationService.validateDescription('Esta é uma descrição válida com mais de 10 caracteres');
        expect(result, isNull);
      });

      test('should fail validation with empty description', () {
        final result = ValidationService.validateDescription('');
        expect(result, equals('Descrição é obrigatória'));
      });

      test('should fail validation with short description', () {
        final result = ValidationService.validateDescription('Curta');
        expect(result, equals('Descrição deve ter pelo menos 10 caracteres'));
      });

      test('should fail validation with long description', () {
        final longDescription = 'a' * 501;
        final result = ValidationService.validateDescription(longDescription);
        expect(result, equals('Descrição deve ter no máximo 500 caracteres'));
      });
    });

    group('Phone Validation', () {
      test('should validate valid phone', () {
        final result = ValidationService.validatePhone('(11) 98765-4321');
        expect(result, isNull);
      });

      test('should accept null phone', () {
        final result = ValidationService.validatePhone(null);
        expect(result, isNull);
      });

      test('should accept empty phone', () {
        final result = ValidationService.validatePhone('');
        expect(result, isNull);
      });

      test('should fail validation with invalid phone', () {
        final result = ValidationService.validatePhone('123');
        expect(result, equals('Telefone inválido'));
      });
    });

    group('Address Label Validation', () {
      test('should validate valid label', () {
        final result = ValidationService.validateAddressLabel('Casa');
        expect(result, isNull);
      });

      test('should accept null label', () {
        final result = ValidationService.validateAddressLabel(null);
        expect(result, isNull);
      });

      test('should accept empty label', () {
        final result = ValidationService.validateAddressLabel('');
        expect(result, isNull);
      });

      test('should fail validation with short label', () {
        final result = ValidationService.validateAddressLabel('A');
        expect(result, equals('Nome do endereço deve ter pelo menos 2 caracteres'));
      });

      test('should fail validation with long label', () {
        final longLabel = 'a' * 51;
        final result = ValidationService.validateAddressLabel(longLabel);
        expect(result, equals('Nome do endereço deve ter no máximo 50 caracteres'));
      });
    });
  });
} 