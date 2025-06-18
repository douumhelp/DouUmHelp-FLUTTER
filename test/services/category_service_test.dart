import 'package:flutter_test/flutter_test.dart';
import 'package:DouUmHelp/Services/category_service.dart';
import 'package:DouUmHelp/models/categoria.dart';

void main() {
  group('CategoryService Tests', () {
    late CategoryService categoryService;

    setUp(() {
      categoryService = CategoryService();
    });

    group('Singleton Pattern', () {
      test('should return same instance', () {
        final instance1 = CategoryService();
        final instance2 = CategoryService();
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Initialization', () {
      test('should initialize with categories', () {
        expect(categoryService.cachedCategories, isNotEmpty);
        expect(categoryService.cachedCategories.length, equals(8));
      });

      test('should have correct first category', () {
        final firstCategory = categoryService.cachedCategories.first;
        expect(firstCategory.id, equals('1'));
        expect(firstCategory.categoria, equals('Serviços Domésticos'));
        expect(firstCategory.icon, equals('home'));
        expect(firstCategory.isExpanded, isFalse);
      });

      test('should have correct last category', () {
        final lastCategory = categoryService.cachedCategories.last;
        expect(lastCategory.id, equals('8'));
        expect(lastCategory.categoria, equals('Fretes'));
        expect(lastCategory.icon, equals('local_shipping'));
        expect(lastCategory.isExpanded, isFalse);
      });
    });

    group('getCategories', () {
      test('should return cached categories', () async {
        final categories = await categoryService.getCategories();
        expect(categories, equals(categoryService.cachedCategories));
        expect(categories.length, equals(8));
      });

      test('should return same categories on multiple calls', () async {
        final categories1 = await categoryService.getCategories();
        final categories2 = await categoryService.getCategories();
        expect(categories1, equals(categories2));
      });

      test('should force refresh when requested', () async {
        // First call
        final categories1 = await categoryService.getCategories();
        
        // Modify a category
        categoryService.updateCategoryExpansion('1', true);
        
        // Force refresh
        final categories2 = await categoryService.getCategories(forceRefresh: true);
        
        // Should have reset the expansion
        expect(categories2.first.isExpanded, isFalse);
      });

      test('should refresh when cache is empty', () async {
        // Clear cache by creating new instance
        final newService = CategoryService();
        
        final categories = await newService.getCategories();
        expect(categories, isNotEmpty);
        expect(categories.length, equals(8));
      });
    });

    group('updateCategoryExpansion', () {
      test('should update category expansion to true', () {
        final categoryId = '1';
        categoryService.updateCategoryExpansion(categoryId, true);
        
        final updatedCategory = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId);
        expect(updatedCategory.isExpanded, isTrue);
      });

      test('should update category expansion to false', () {
        final categoryId = '1';
        // First expand
        categoryService.updateCategoryExpansion(categoryId, true);
        // Then collapse
        categoryService.updateCategoryExpansion(categoryId, false);
        
        final updatedCategory = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId);
        expect(updatedCategory.isExpanded, isFalse);
      });

      test('should not affect other categories when updating one', () {
        final categoryId = '1';
        final otherCategoryId = '2';
        
        // Update first category
        categoryService.updateCategoryExpansion(categoryId, true);
        
        // Check that other category is not affected
        final otherCategory = categoryService.cachedCategories
            .firstWhere((c) => c.id == otherCategoryId);
        expect(otherCategory.isExpanded, isFalse);
      });

      test('should handle non-existent category id', () {
        const nonExistentId = '999';
        
        // Should not throw exception
        expect(() => categoryService.updateCategoryExpansion(nonExistentId, true), returnsNormally);
        
        // Should not affect any categories
        final allCollapsed = categoryService.cachedCategories
            .every((c) => !c.isExpanded);
        expect(allCollapsed, isTrue);
      });

      test('should preserve other category properties when updating expansion', () {
        final categoryId = '1';
        final originalCategory = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId);
        
        categoryService.updateCategoryExpansion(categoryId, true);
        
        final updatedCategory = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId);
        
        // Other properties should remain the same
        expect(updatedCategory.id, equals(originalCategory.id));
        expect(updatedCategory.categoria, equals(originalCategory.categoria));
        expect(updatedCategory.icon, equals(originalCategory.icon));
        expect(updatedCategory.subcategorias, equals(originalCategory.subcategorias));
        
        // Only isExpanded should change
        expect(updatedCategory.isExpanded, isTrue);
        expect(originalCategory.isExpanded, isFalse);
      });

      test('should handle multiple expansion updates', () {
        final categoryId1 = '1';
        final categoryId2 = '2';
        
        // Update multiple categories
        categoryService.updateCategoryExpansion(categoryId1, true);
        categoryService.updateCategoryExpansion(categoryId2, true);
        
        // Verify both are expanded
        final category1 = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId1);
        final category2 = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId2);
        
        expect(category1.isExpanded, isTrue);
        expect(category2.isExpanded, isTrue);
      });

      test('should handle toggle expansion', () {
        final categoryId = '1';
        
        // Toggle multiple times
        categoryService.updateCategoryExpansion(categoryId, true);
        categoryService.updateCategoryExpansion(categoryId, false);
        categoryService.updateCategoryExpansion(categoryId, true);
        
        final category = categoryService.cachedCategories
            .firstWhere((c) => c.id == categoryId);
        expect(category.isExpanded, isTrue);
      });
    });

    group('Category Content Validation', () {
      test('should have all required categories', () {
        final categories = categoryService.cachedCategories;
        final categoryNames = categories.map((c) => c.categoria).toList();
        
        expect(categoryNames, contains('Serviços Domésticos'));
        expect(categoryNames, contains('Serviços de Software'));
        expect(categoryNames, contains('Serviço Online'));
        expect(categoryNames, contains('Serviço Veicular'));
        expect(categoryNames, contains('Serviço Pet'));
        expect(categoryNames, contains('Serviço Humano'));
        expect(categoryNames, contains('Serviços Comercial'));
        expect(categoryNames, contains('Fretes'));
      });

      test('should have unique IDs', () {
        final categories = categoryService.cachedCategories;
        final ids = categories.map((c) => c.id).toSet();
        expect(ids.length, equals(categories.length));
      });

      test('should have non-empty subcategories for all categories', () {
        final categories = categoryService.cachedCategories;
        
        for (final category in categories) {
          expect(category.subcategorias, isNotEmpty);
          expect(category.subcategorias.length, greaterThan(0));
        }
      });

      test('should have valid icons for all categories', () {
        final categories = categoryService.cachedCategories;
        
        for (final category in categories) {
          expect(category.icon, isNotEmpty);
          expect(category.icon.length, greaterThan(0));
        }
      });
    });

    group('Edge Cases', () {
      test('should handle empty string category id', () {
        expect(() => categoryService.updateCategoryExpansion('', true), returnsNormally);
      });

      test('should maintain list integrity after updates', () {
        final originalLength = categoryService.cachedCategories.length;
        final originalIds = categoryService.cachedCategories.map((c) => c.id).toList();
        
        // Perform multiple updates
        categoryService.updateCategoryExpansion('1', true);
        categoryService.updateCategoryExpansion('2', true);
        categoryService.updateCategoryExpansion('3', false);
        
        // Verify list integrity
        expect(categoryService.cachedCategories.length, equals(originalLength));
        expect(categoryService.cachedCategories.map((c) => c.id).toList(), equals(originalIds));
      });
    });
  });
} 