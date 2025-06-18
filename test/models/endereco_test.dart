import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/models/endereco.dart';

void main() {
  group('Endereco Model Tests', () {
    test('should create Endereco with required parameters', () {
      // Arrange
      const cep = '12345-678';
      const addressLine = 'Rua Teste';
      const addressNumber = '123';
      const city = 'São Paulo';
      const state = 'SP';

      // Act
      final endereco = Endereco(
        cep: cep,
        addressLine: addressLine,
        addressNumber: addressNumber,
        city: city,
        state: state,
      );

      // Assert
      expect(endereco.cep, equals(cep));
      expect(endereco.addressLine, equals(addressLine));
      expect(endereco.addressNumber, equals(addressNumber));
      expect(endereco.city, equals(city));
      expect(endereco.state, equals(state));
      expect(endereco.latitude, equals(1.0));
      expect(endereco.longitude, equals(1.0));
      expect(endereco.id, isNull);
      expect(endereco.neighborhood, isNull);
      expect(endereco.label, isNull);
      expect(endereco.userId, isNull);
    });

    test('should create Endereco with all parameters', () {
      // Arrange
      const id = '1';
      const cep = '12345-678';
      const addressLine = 'Rua Teste';
      const addressNumber = '123';
      const neighborhood = 'Centro';
      const label = 'Casa';
      const city = 'São Paulo';
      const state = 'SP';
      const latitude = -23.5505;
      const longitude = -46.6333;
      const userId = 'user123';

      // Act
      final endereco = Endereco(
        id: id,
        cep: cep,
        addressLine: addressLine,
        addressNumber: addressNumber,
        neighborhood: neighborhood,
        label: label,
        city: city,
        state: state,
        latitude: latitude,
        longitude: longitude,
        userId: userId,
      );

      // Assert
      expect(endereco.id, equals(id));
      expect(endereco.cep, equals(cep));
      expect(endereco.addressLine, equals(addressLine));
      expect(endereco.addressNumber, equals(addressNumber));
      expect(endereco.neighborhood, equals(neighborhood));
      expect(endereco.label, equals(label));
      expect(endereco.city, equals(city));
      expect(endereco.state, equals(state));
      expect(endereco.latitude, equals(latitude));
      expect(endereco.longitude, equals(longitude));
      expect(endereco.userId, equals(userId));
    });

    test('should create Endereco from JSON with all fields', () {
      // Arrange
      final json = {
        'id': '1',
        'cep': '12345-678',
        'addressLine': 'Rua Teste',
        'addressNumber': '123',
        'neighborhood': 'Centro',
        'label': 'Casa',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5505,
        'longitude': -46.6333,
        'userId': 'user123',
      };

      // Act
      final endereco = Endereco.fromJson(json);

      // Assert
      expect(endereco.id, equals('1'));
      expect(endereco.cep, equals('12345-678'));
      expect(endereco.addressLine, equals('Rua Teste'));
      expect(endereco.addressNumber, equals('123'));
      expect(endereco.neighborhood, equals('Centro'));
      expect(endereco.label, equals('Casa'));
      expect(endereco.city, equals('São Paulo'));
      expect(endereco.state, equals('SP'));
      expect(endereco.latitude, equals(-23.5505));
      expect(endereco.longitude, equals(-46.6333));
      expect(endereco.userId, equals('user123'));
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'id': null,
        'cep': null,
        'addressLine': null,
        'addressNumber': null,
        'neighborhood': null,
        'label': null,
        'city': null,
        'state': null,
        'latitude': null,
        'longitude': null,
        'userId': null,
      };

      // Act
      final endereco = Endereco.fromJson(json);

      // Assert
      expect(endereco.id, isNull);
      expect(endereco.cep, equals(''));
      expect(endereco.addressLine, equals(''));
      expect(endereco.addressNumber, equals(''));
      expect(endereco.neighborhood, isNull);
      expect(endereco.label, isNull);
      expect(endereco.city, equals(''));
      expect(endereco.state, equals(''));
      expect(endereco.latitude, equals(1.0));
      expect(endereco.longitude, equals(1.0));
      expect(endereco.userId, isNull);
    });

    test('should handle numeric userId in JSON', () {
      // Arrange
      final json = {
        'cep': '12345-678',
        'addressLine': 'Rua Teste',
        'addressNumber': '123',
        'city': 'São Paulo',
        'state': 'SP',
        'userId': 123,
      };

      // Act
      final endereco = Endereco.fromJson(json);

      // Assert
      expect(endereco.userId, isNull);
    });

    test('should convert to JSON with all fields', () {
      // Arrange
      final endereco = Endereco(
        id: '1',
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        neighborhood: 'Centro',
        label: 'Casa',
        city: 'São Paulo',
        state: 'SP',
        latitude: -23.5505,
        longitude: -46.6333,
        userId: 'user123',
      );

      // Act
      final json = endereco.toJson();

      // Assert
      expect(json['id'], equals('1'));
      expect(json['cep'], equals('12345-678'));
      expect(json['addressLine'], equals('Rua Teste'));
      expect(json['addressNumber'], equals('123'));
      expect(json['neighborhood'], equals('Centro'));
      expect(json['label'], equals('Casa'));
      expect(json['city'], equals('São Paulo'));
      expect(json['state'], equals('SP'));
      expect(json['latitude'], equals(-23.5505));
      expect(json['longitude'], equals(-46.6333));
      expect(json['userId'], equals('user123'));
    });

    test('should convert to JSON without optional fields', () {
      // Arrange
      final endereco = Endereco(
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        city: 'São Paulo',
        state: 'SP',
      );

      // Act
      final json = endereco.toJson();

      // Assert
      expect(json['id'], isNull);
      expect(json['cep'], equals('12345-678'));
      expect(json['addressLine'], equals('Rua Teste'));
      expect(json['addressNumber'], equals('123'));
      expect(json['neighborhood'], isNull);
      expect(json['label'], isNull);
      expect(json['city'], equals('São Paulo'));
      expect(json['state'], equals('SP'));
      expect(json['latitude'], equals(1.0));
      expect(json['longitude'], equals(1.0));
      expect(json['userId'], isNull);
    });

    test('should convert to JSON with empty optional fields', () {
      // Arrange
      final endereco = Endereco(
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        neighborhood: '',
        label: '',
        city: 'São Paulo',
        state: 'SP',
      );

      // Act
      final json = endereco.toJson();

      // Assert
      expect(json['neighborhood'], isNull);
      expect(json['label'], isNull);
    });

    test('should return correct string representation', () {
      // Arrange
      final endereco = Endereco(
        id: '1',
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        neighborhood: 'Centro',
        label: 'Casa',
        city: 'São Paulo',
        state: 'SP',
        latitude: -23.5505,
        longitude: -46.6333,
        userId: 'user123',
      );

      // Act
      final stringRep = endereco.toString();

      // Assert
      expect(stringRep, contains('Endereco'));
      expect(stringRep, contains('id: 1'));
      expect(stringRep, contains('cep: 12345-678'));
      expect(stringRep, contains('addressLine: Rua Teste'));
      expect(stringRep, contains('city: São Paulo'));
      expect(stringRep, contains('state: SP'));
    });

    test('should handle default latitude and longitude', () {
      // Arrange & Act
      final endereco = Endereco(
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        city: 'São Paulo',
        state: 'SP',
      );

      // Assert
      expect(endereco.latitude, equals(1.0));
      expect(endereco.longitude, equals(1.0));
    });

    test('should handle custom latitude and longitude', () {
      // Arrange & Act
      final endereco = Endereco(
        cep: '12345-678',
        addressLine: 'Rua Teste',
        addressNumber: '123',
        city: 'São Paulo',
        state: 'SP',
        latitude: -23.5505,
        longitude: -46.6333,
      );

      // Assert
      expect(endereco.latitude, equals(-23.5505));
      expect(endereco.longitude, equals(-46.6333));
    });
  });
} 