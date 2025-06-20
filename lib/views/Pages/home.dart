import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../../utils/config.dart';
import '../address_list_screen.dart';

IconData getIconForCategory(String name) {
  switch (name.toLowerCase()) {
    case 'elétrica':
      return Icons.flash_on;
    case 'mecânica':
      return Icons.build;
    case 'serviços em geral':
      return Icons.home_repair_service;
    case 'pets':
      return Icons.pets;
    case 'pinturas':
      return Icons.format_paint;
    case 'hidráulica':
      return Icons.water_damage;
    case 'montagem':
      return Icons.chair_alt;
    case 'jardinagem':
      return Icons.grass;
    default:
      return Icons.category; 
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class Categoria {
  final String id;
  final String name;

  Categoria({required this.id, required this.name});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool loading = true;
  List<Categoria> categorias = [];
  bool loadingCategorias = true;

  @override
  void initState() {
    super.initState();
    buscarUsuario();
    buscarCategorias();
  }

  Future<void> buscarCategorias() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  final response = await http.get(
    Uri.parse(ApiConfig.categories),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    setState(() {
      categorias = data.map((json) => Categoria.fromJson(json)).toList();
      loadingCategorias = false;
    });
  } else {
    print('Erro ao buscar categorias: ${response.statusCode}');
    setState(() => loadingCategorias = false);
  }
}

  Future<void> buscarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('userId'); 


      final response = await http.get(
      Uri.parse('https://api-production-d036.up.railway.app/userpf/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final usuario = jsonDecode(response.body);
      setState(() {
        userName = usuario['firstName']; 
        loading = false;
      });
    } else {
      print('Erro ao buscar usuário: ${response.statusCode}');
      setState(() => loading = false);
    }
  }

  
  

  @override
  Widget build(BuildContext context) {
    if(loading){
      return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
    }
   return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Text(
      'Rua Bolsonaro, 22',
      style: GoogleFonts.outfit(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: const [
      Icon(Icons.person_outline),
      SizedBox(width: 8),
      Icon(Icons.notifications_none),
      SizedBox(width: 16),
    ],
  ),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xFFFACC15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.black, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                userName ?? 'Usuário',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text('Configurações', style: GoogleFonts.outfit()),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text('Meus Endereços', style: GoogleFonts.outfit()),
          onTap: () {
            print('Botão Meus Endereços clicado');
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressListScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: Text('Histórico de Serviços', style: GoogleFonts.outfit()),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: Text('Favoritos', style: GoogleFonts.outfit()),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text('Ajuda', style: GoogleFonts.outfit()),
          onTap: () => Navigator.pop(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text('Sair', style: GoogleFonts.outfit()),
          onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          },
        ),
      ],
    ),
  ),
  backgroundColor: Colors.white,
  body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF083A5E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desconto Especial em Manutenção e Instalação de Ar-Condicionado!',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFACC15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'HELP25',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use e ganhe 15% OFF',
                          style: GoogleFonts.outfit(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            loadingCategorias
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 160,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        direction: Axis.vertical,
                        spacing: 16,
                        runSpacing: 16,
                        children: categorias.map((categoria) {
                          return SizedBox(
                            width: 100,
                            child: ServiceIcon(
                              icon: getIconForCategory(categoria.name),
                              label: categoria.name,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
            const SizedBox(height: 24),
            Text(
              'Melhores Prestadores do Mês na sua Região!',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                HighlightUser(position: 2, name: 'Eduardo - Mecânico'),
                HighlightUser(position: 1, name: 'Isaac - Pintor'),
                HighlightUser(position: 3, name: 'Nathan - Encanador'),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFACC15),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.touch_app),
                label: Text(
                  'Solicitar um HELP',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BANNER DE CAMPANHA',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFACC15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'CUPOM',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use e ganhe 15% OFF',
                          style: GoogleFonts.outfit(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

  }
}

class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: Color(0xFFFACC15)),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(fontSize: 12),
          ),
        )
      ],
    );
  }
}

class HighlightUser extends StatelessWidget {
  final int position;
  final String name;

  const HighlightUser({super.key, required this.position, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Color(0xFFFACC15),
          child: Text('$positionº'),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: GoogleFonts.outfit(fontSize: 12),
        ),
      ],
    );
  }
}
