import 'package:flutter/material.dart';
import 'dart:async';
import '../services/category_service.dart';
import '../services/auth_service.dart';
import '../models/categoria.dart';
import 'base_viewmodel.dart';
import 'category_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  final CategoryViewModel _categoryViewModel = CategoryViewModel();
  
  final PageController pageController = PageController(viewportFraction: 0.9);
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  int get currentPage => _currentPage;
  CategoryViewModel get categoryViewModel => _categoryViewModel;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  Future<void> loadInitialData() async {
    await executeAsync(() async {
      await _categoryViewModel.loadCategories();
    });
  }

  Future<void> refreshData() async {
    await executeAsync(() async {
      await _categoryViewModel.refreshCategories();
    });
  }

  Future<void> logout() async {
    await executeAsync(() async {
      await AuthService.logout();
    });
  }

  void showCategoryDetails(BuildContext context, dynamic category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        _categoryViewModel.getIconForCategory(category.icon),
                        color: const Color(0xFFFACC15),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category.categoria,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: category.subcategorias.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final subcategoria = category.subcategorias[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    title: Text(
                      subcategoria,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      // Implementar navegação para detalhes da subcategoria
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    stopAutoPlay();
    super.dispose();
  }
} 