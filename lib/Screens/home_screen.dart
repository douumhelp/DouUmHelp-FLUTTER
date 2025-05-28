import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/categoria.dart';
import '../services/auth_service.dart';
import '../services/category_service.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final CategoryService _categoryService = CategoryService();
  bool _isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print("HomeScreen - initState");
    _loadCategorias();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadCategorias() async {
    print("HomeScreen - _loadCategorias iniciado");
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final categorias = await _categoryService.getCategories(forceRefresh: true);
      print('HomeScreen - Categorias carregadas: ${categorias.length}');
      for (var cat in categorias) {
        print('HomeScreen - Categoria: ${cat.categoria}, Icon: ${cat.icon}, Subcategorias: ${cat.subcategorias.length}');
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('HomeScreen - Erro ao carregar categorias: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('Erro ao carregar categorias');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _toggleCategory(Categoria categoria) {
    print('Categoria selecionada: ${categoria.categoria}');
    print('Subcategorias: ${categoria.subcategorias}');
    
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
                    color: Colors.grey.withOpacity(0.1),
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
                        _getIconData(categoria.icon),
                        color: const Color(0xFFFACC15),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          categoria.categoria,
                          style: GoogleFonts.outfit(
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
                itemCount: categoria.subcategorias.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final subcategoria = categoria.subcategorias[index];
                  print('Construindo subcategoria: $subcategoria');
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    title: Text(
                      subcategoria,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Aqui você pode implementar a navegação para a tela
                      // de detalhes da subcategoria ou prestadores de serviço
                      Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.brown),
          onPressed: () {
            // Implementar menu
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              'Meu Endereço',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Implementar notificações
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '1',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.brown),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategorias,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Carousel section
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          PageView(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: [
                              _buildPromotionCard(
                                'INDIQUE E GANHE!',
                                'INDIQUE UM AMIGO E GANHE',
                                'DESCONTOS DE ATÉ 50%',
                              ),
                              _buildPromotionCard(
                                'PROMOÇÃO ESPECIAL',
                                '',
                                'SERVIÇOS DOMÉSTICOS',
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                2,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? const Color(0xFFFACC15)
                                        : Colors.grey[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories section
                    _buildCategoriasSection(),

                    const SizedBox(height: 24),

                    // Melhores Prestadores
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFACC15),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Melhores Prestadores do Mês',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProviderCard(
                                name: 'Nathan',
                                role: 'Profissional Linux',
                                position: '2º',
                                rating: 5,
                              ),
                              _buildProviderCard(
                                name: 'Eduardo',
                                role: 'Hidráulica',
                                position: '1º',
                                rating: 5,
                                isHighlighted: true,
                              ),
                              _buildProviderCard(
                                name: 'Enzo',
                                role: 'Eletricista',
                                position: '3º',
                                rating: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão Solicitar Help
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFACC15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Implementar solicitação de help
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.handshake, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              'Solicitar um HELP',
                              style: GoogleFonts.outfit(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Perguntas Frequentes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perguntas Frequentes',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFAQItem('Como altero meus dados de perfil?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Espaço para o botão flutuante
                  ],
                ),
              ),
            ),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.build, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Meus Serviços',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriasSection() {
    final categorias = _categoryService.cachedCategories;
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.category, color: Color(0xFFFACC15)),
              const SizedBox(width: 8),
              Text(
                'Categorias',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (categorias.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('Nenhuma categoria disponível'),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.9,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              return InkWell(
                onTap: () => _toggleCategory(categoria),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFACC15).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconData(categoria.icon),
                          color: const Color(0xFFFACC15),
                          size: 24,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            categoria.categoria,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  IconData _getIconData(String icon) {
    switch (icon.toLowerCase()) {
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

  Widget _buildProviderCard({
    required String name,
    required String role,
    required String position,
    required int rating,
    bool isHighlighted = false,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: const Color(0xFFFACC15), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            role,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              rating,
              (index) => const Icon(
                Icons.star,
                color: Color(0xFFFACC15),
                size: 14,
              ),
            ),
          ),
          Text(
            position,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFACC15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          question,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Implementar navegação para resposta
        },
      ),
    );
  }

  Widget _buildPromotionCard(String title, String subtitle, String highlight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            Text(
              highlight,
              style: GoogleFonts.outfit(
                color: const Color(0xFFFACC15),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 