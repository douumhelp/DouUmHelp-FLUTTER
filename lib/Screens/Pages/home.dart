import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    buscarUsuario();
  }

  Future<void> buscarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
  
   if (token == null || userId == null) {
      print('Token ou ID do usuário não encontrados');
      setState(() => loading = false);
      return;
    }

      final response = await http.get(
      Uri.parse('https://api.douumhelp.com.br/userpf/$userId'),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu),
                    Text(
                      'Rua Bolsonaro, 22',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Icon(Icons.notifications_none),
                      ],
                    )
                  ],
                ),
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
                                  color: Color(0xFFFACC15),
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
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ServiceIcon(icon: Icons.flash_on, label: 'Elétrica'),
                    ServiceIcon(icon: Icons.build, label: 'Mecânica'),
                    ServiceIcon(icon: Icons.home_repair_service, label: 'Serviços em Geral'),
                    ServiceIcon(icon: Icons.pets, label: 'Pets'),
                    ServiceIcon(icon: Icons.format_paint, label: 'Pinturas'),
                    ServiceIcon(icon: Icons.water_damage, label: 'Hidráulica'),
                    ServiceIcon(icon: Icons.chair_alt, label: 'Montagem'),
                    ServiceIcon(icon: Icons.grass, label: 'Jardinagem'),
                  ],
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
                      backgroundColor: Color(0xFFFACC15),
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
                                color: Color(0xFFFACC15),
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
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 12),
        ),
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
