import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/models/solicitacao_servico.dart';

void main() {
  group('SolicitacaoServico Model Tests', () {
    late DateTime testDate;
    late DateTime createdAt;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      createdAt = DateTime(2024, 1, 10, 9, 0);
    });

    test('should create SolicitacaoServico with required parameters', () {
      // Arrange
      const id = '1';
      const categoryId = 'cat1';
      const description = 'Test service request';
      const minValue = 50.0;
      const maxValue = 100.0;
      const addressId = 'addr1';
      const userPFId = 'user1';

      // Act
      final solicitacao = SolicitacaoServico(
        id: id,
        categoryId: categoryId,
        description: description,
        scheduledDate: testDate,
        minValue: minValue,
        maxValue: maxValue,
        addressId: addressId,
        userPFId: userPFId,
        createdAt: createdAt,
      );

      // Assert
      expect(solicitacao.id, equals(id));
      expect(solicitacao.categoryId, equals(categoryId));
      expect(solicitacao.description, equals(description));
      expect(solicitacao.scheduledDate, equals(testDate));
      expect(solicitacao.minValue, equals(minValue));
      expect(solicitacao.maxValue, equals(maxValue));
      expect(solicitacao.addressId, equals(addressId));
      expect(solicitacao.userPFId, equals(userPFId));
      expect(solicitacao.createdAt, equals(createdAt));
      expect(solicitacao.status, equals('pendente'));
    });

    test('should create SolicitacaoServico with custom status', () {
      // Arrange
      const status = 'aceito';

      // Act
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Test service request',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
        status: status,
      );

      // Assert
      expect(solicitacao.status, equals(status));
    });

    test('should create SolicitacaoServico from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'categoryId': 'cat1',
        'description': 'Test service request',
        'scheduledDate': testDate.toIso8601String(),
        'minValue': 50.0,
        'maxValue': 100.0,
        'addressId': 'addr1',
        'userPFId': 'user1',
        'createdAt': createdAt.toIso8601String(),
        'status': 'aceito',
      };

      // Act
      final solicitacao = SolicitacaoServico.fromJson(json);

      // Assert
      expect(solicitacao.id, equals('1'));
      expect(solicitacao.categoryId, equals('cat1'));
      expect(solicitacao.description, equals('Test service request'));
      expect(solicitacao.scheduledDate, equals(testDate));
      expect(solicitacao.minValue, equals(50.0));
      expect(solicitacao.maxValue, equals(100.0));
      expect(solicitacao.addressId, equals('addr1'));
      expect(solicitacao.userPFId, equals('user1'));
      expect(solicitacao.createdAt, equals(createdAt));
      expect(solicitacao.status, equals('aceito'));
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'categoryId': 'cat1',
        'description': 'Test service request',
        'scheduledDate': testDate.toIso8601String(),
        'minValue': null,
        'maxValue': null,
        'addressId': 'addr1',
        'userPFId': 'user1',
        'createdAt': createdAt.toIso8601String(),
        'status': null,
      };

      // Act
      final solicitacao = SolicitacaoServico.fromJson(json);

      // Assert
      expect(solicitacao.minValue, equals(0.0));
      expect(solicitacao.maxValue, equals(0.0));
      expect(solicitacao.status, equals('pendente'));
    });

    test('should convert to JSON', () {
      // Arrange
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Test service request',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
        status: 'aceito',
      );

      // Act
      final json = solicitacao.toJson();

      // Assert
      expect(json['id'], equals('1'));
      expect(json['categoryId'], equals('cat1'));
      expect(json['description'], equals('Test service request'));
      expect(json['scheduledDate'], equals(testDate.toIso8601String()));
      expect(json['minValue'], equals(50.0));
      expect(json['maxValue'], equals(100.0));
      expect(json['addressId'], equals('addr1'));
      expect(json['userPFId'], equals('user1'));
      expect(json['createdAt'], equals(createdAt.toIso8601String()));
      expect(json['status'], equals('aceito'));
    });

    test('should create copy with updated fields', () {
      // Arrange
      final original = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Original description',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
        status: 'pendente',
      );

      // Act
      final copy = original.copyWith(
        description: 'Updated description',
        status: 'aceito',
        minValue: 75.0,
      );

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.categoryId, equals(original.categoryId));
      expect(copy.description, equals('Updated description'));
      expect(copy.scheduledDate, equals(original.scheduledDate));
      expect(copy.minValue, equals(75.0));
      expect(copy.maxValue, equals(original.maxValue));
      expect(copy.addressId, equals(original.addressId));
      expect(copy.userPFId, equals(original.userPFId));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.status, equals('aceito'));
    });

    test('should create copy with all fields updated', () {
      // Arrange
      final original = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Original description',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
        status: 'pendente',
      );

      final newDate = DateTime(2024, 2, 1, 14, 0);
      final newCreatedAt = DateTime(2024, 1, 20, 10, 0);

      // Act
      final copy = original.copyWith(
        id: '2',
        categoryId: 'cat2',
        description: 'Updated description',
        scheduledDate: newDate,
        minValue: 75.0,
        maxValue: 150.0,
        addressId: 'addr2',
        userPFId: 'user2',
        createdAt: newCreatedAt,
        status: 'concluido',
      );

      // Assert
      expect(copy.id, equals('2'));
      expect(copy.categoryId, equals('cat2'));
      expect(copy.description, equals('Updated description'));
      expect(copy.scheduledDate, equals(newDate));
      expect(copy.minValue, equals(75.0));
      expect(copy.maxValue, equals(150.0));
      expect(copy.addressId, equals('addr2'));
      expect(copy.userPFId, equals('user2'));
      expect(copy.createdAt, equals(newCreatedAt));
      expect(copy.status, equals('concluido'));
    });

    test('should create copy with no changes', () {
      // Arrange
      final original = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Test description',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
        status: 'pendente',
      );

      // Act
      final copy = original.copyWith();

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.categoryId, equals(original.categoryId));
      expect(copy.description, equals(original.description));
      expect(copy.scheduledDate, equals(original.scheduledDate));
      expect(copy.minValue, equals(original.minValue));
      expect(copy.maxValue, equals(original.maxValue));
      expect(copy.addressId, equals(original.addressId));
      expect(copy.userPFId, equals(original.userPFId));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.status, equals(original.status));
    });

    test('should handle different status values', () {
      // Arrange
      final statuses = ['pendente', 'aceito', 'em_andamento', 'concluido', 'cancelado'];

      // Act & Assert
      for (final status in statuses) {
        final solicitacao = SolicitacaoServico(
          id: '1',
          categoryId: 'cat1',
          description: 'Test',
          scheduledDate: testDate,
          minValue: 50.0,
          maxValue: 100.0,
          addressId: 'addr1',
          userPFId: 'user1',
          createdAt: createdAt,
          status: status,
        );

        expect(solicitacao.status, equals(status));
      }
    });

    test('should handle zero values for min and max', () {
      // Arrange & Act
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Test',
        scheduledDate: testDate,
        minValue: 0.0,
        maxValue: 0.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
      );

      // Assert
      expect(solicitacao.minValue, equals(0.0));
      expect(solicitacao.maxValue, equals(0.0));
    });

    test('should handle large values for min and max', () {
      // Arrange & Act
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: 'Test',
        scheduledDate: testDate,
        minValue: 1000000.0,
        maxValue: 9999999.99,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
      );

      // Assert
      expect(solicitacao.minValue, equals(1000000.0));
      expect(solicitacao.maxValue, equals(9999999.99));
    });

    test('should handle special characters in description', () {
      // Arrange
      const description = 'Serviço com caracteres especiais: áéíóú çãõ!@#\$%';

      // Act
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: description,
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
      );

      // Assert
      expect(solicitacao.description, equals(description));
    });

    test('should handle empty description', () {
      // Arrange & Act
      final solicitacao = SolicitacaoServico(
        id: '1',
        categoryId: 'cat1',
        description: '',
        scheduledDate: testDate,
        minValue: 50.0,
        maxValue: 100.0,
        addressId: 'addr1',
        userPFId: 'user1',
        createdAt: createdAt,
      );

      // Assert
      expect(solicitacao.description, equals(''));
    });
  });
} 