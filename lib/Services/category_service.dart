import '../models/categoria.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  List<Categoria> _cachedCategories = [];

  factory CategoryService() {
    return _instance;
  }

  CategoryService._internal() {
    _initializeCategories();
  }

  void _initializeCategories() {
    _cachedCategories = Categoria.getCategorias();
  }

  List<Categoria> get cachedCategories => _cachedCategories;

  Future<List<Categoria>> getCategories({bool forceRefresh = false}) async {
    if (_cachedCategories.isEmpty || forceRefresh) {
      _initializeCategories();
    }
    return _cachedCategories;
  }

  void updateCategoryExpansion(String categoryId, bool isExpanded) {
    final index = _cachedCategories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      final updatedCategories = List<Categoria>.from(_cachedCategories);
      updatedCategories[index] = Categoria(
        id: _cachedCategories[index].id,
        categoria: _cachedCategories[index].categoria,
        icon: _cachedCategories[index].icon,
        subcategorias: _cachedCategories[index].subcategorias,
        isExpanded: isExpanded,
      );
      _cachedCategories = updatedCategories;
    }
  }
} 