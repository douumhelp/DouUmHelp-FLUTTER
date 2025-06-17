import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/categoria.dart';
import 'base_viewmodel.dart';

class CategoryViewModel extends BaseViewModel {
  final CategoryService _categoryService = CategoryService();
  
  List<Categoria> _categorias = [];
  Categoria? _selectedCategory;

  List<Categoria> get categorias => _categorias;
  Categoria? get selectedCategory => _selectedCategory;

  void setSelectedCategory(Categoria? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadCategories({bool forceRefresh = false}) async {
    await executeAsync(() async {
      final categories = await _categoryService.getCategories(forceRefresh: forceRefresh);
      _categorias = categories;
    });
  }

  Future<void> refreshCategories() async {
    await loadCategories(forceRefresh: true);
  }

  List<String> getSubcategoriesForCategory(String categoryName) {
    final category = _categorias.firstWhere(
      (cat) => cat.categoria == categoryName,
      orElse: () => Categoria(id: '', categoria: '', icon: '', subcategorias: []),
    );
    return category.subcategorias;
  }

  IconData getIconForCategory(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'code':
        return Icons.code;
      case 'language':
        return Icons.language;
      case 'directions_car':
        return Icons.directions_car;
      case 'pets':
        return Icons.pets;
      case 'person':
        return Icons.person;
      case 'store':
        return Icons.store;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.category;
    }
  }
} 