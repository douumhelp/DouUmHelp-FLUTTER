import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/models/categoria.dart';

void main() {
  group('Categoria Model Tests', () {
    test('should create Categoria with required parameters', () {
      // Arrange
      const id = '1';
      const categoria = 'Test Category';
      const icon = 'test_icon';
      const subcategorias = ['Sub1', 'Sub2'];

      // Act
      final categoriaObj = Categoria(
        id: id,
        categoria: categoria,
        icon: icon,
        subcategorias: subcategorias,
      );

      // Assert
      expect(categoriaObj.id, equals(id));
      expect(categoriaObj.categoria, equals(categoria));
      expect(categoriaObj.icon, equals(icon));
      expect(categoriaObj.subcategorias, equals(subcategorias));
      expect(categoriaObj.isExpanded, isFalse);
    });

    test('should create Categoria with isExpanded true', () {
      // Arrange & Act
      final categoriaObj = Categoria(
        id: '1',
        categoria: 'Test',
        icon: 'icon',
        subcategorias: [],
        isExpanded: true,
      );

      // Assert
      expect(categoriaObj.isExpanded, isTrue);
    });

    test('should create Categoria from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'categoria': 'Test Category',
        'icon': 'test_icon',
        'subcategorias': ['Sub1', 'Sub2'],
      };

      // Act
      final categoriaObj = Categoria.fromJson(json);

      // Assert
      expect(categoriaObj.id, equals('1'));
      expect(categoriaObj.categoria, equals('Test Category'));
      expect(categoriaObj.icon, equals('test_icon'));
      expect(categoriaObj.subcategorias, equals(['Sub1', 'Sub2']));
      expect(categoriaObj.isExpanded, isFalse);
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'id': null,
        'categoria': null,
        'icon': null,
        'subcategorias': null,
      };

      // Act
      final categoriaObj = Categoria.fromJson(json);

      // Assert
      expect(categoriaObj.id, equals(''));
      expect(categoriaObj.categoria, equals(''));
      expect(categoriaObj.icon, equals('category'));
      expect(categoriaObj.subcategorias, isEmpty);
    });

    test('should handle empty subcategorias in JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'categoria': 'Test',
        'icon': 'icon',
        'subcategorias': [],
      };

      // Act
      final categoriaObj = Categoria.fromJson(json);

      // Assert
      expect(categoriaObj.subcategorias, isEmpty);
    });

    test('should return predefined categories', () {
      // Act
      final categorias = Categoria.getCategorias();

      // Assert
      expect(categorias, isNotEmpty);
      expect(categorias.length, equals(8));

      // Verify first category
      final firstCategory = categorias.first;
      expect(firstCategory.id, equals('1'));
      expect(firstCategory.categoria, equals('Serviços Domésticos'));
      expect(firstCategory.icon, equals('home'));
      expect(firstCategory.subcategorias, isNotEmpty);

      // Verify last category
      final lastCategory = categorias.last;
      expect(lastCategory.id, equals('8'));
      expect(lastCategory.categoria, equals('Fretes'));
      expect(lastCategory.icon, equals('local_shipping'));
      expect(lastCategory.subcategorias, isNotEmpty);
    });

    test('should verify all categories have unique IDs', () {
      // Act
      final categorias = Categoria.getCategorias();
      final ids = categorias.map((c) => c.id).toSet();

      // Assert
      expect(ids.length, equals(categorias.length));
    });

    test('should verify all categories have non-empty names', () {
      // Act
      final categorias = Categoria.getCategorias();

      // Assert
      for (final categoria in categorias) {
        expect(categoria.categoria, isNotEmpty);
        expect(categoria.icon, isNotEmpty);
      }
    });

    test('should verify all categories have subcategorias', () {
      // Act
      final categorias = Categoria.getCategorias();

      // Assert
      for (final categoria in categorias) {
        expect(categoria.subcategorias, isNotEmpty);
      }
    });

    test('should verify specific category content', () {
      // Act
      final categorias = Categoria.getCategorias();
      final servicosDomesticos = categorias.firstWhere((c) => c.id == '1');

      // Assert
      expect(servicosDomesticos.categoria, equals('Serviços Domésticos'));
      expect(servicosDomesticos.icon, equals('home'));
      expect(servicosDomesticos.subcategorias, contains('Encanador'));
      expect(servicosDomesticos.subcategorias, contains('Eletricista'));
      expect(servicosDomesticos.subcategorias, contains('Pintor'));
    });

    test('should verify software services category', () {
      // Act
      final categorias = Categoria.getCategorias();
      final servicosSoftware = categorias.firstWhere((c) => c.id == '2');

      // Assert
      expect(servicosSoftware.categoria, equals('Serviços de Software'));
      expect(servicosSoftware.icon, equals('code'));
      expect(servicosSoftware.subcategorias, contains('Programação Front End'));
      expect(servicosSoftware.subcategorias, contains('Programador Backend'));
    });
  });
} 