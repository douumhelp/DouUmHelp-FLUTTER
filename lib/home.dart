import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.flash_on, 'label': 'Elétrica'},
    {'icon': Icons.build, 'label': 'Mecânica'},
    {'icon': Icons.handyman, 'label': 'Serviços em Geral'},
    {'icon': Icons.pets, 'label': 'Pets'},
    {'icon': Icons.format_paint, 'label': 'Pinturas'},
    {'icon': Icons.water_damage, 'label': 'Hidráulica'},
    {'icon': Icons.chair, 'label': 'Montagem de Móveis'},
    {'icon': Icons.grass, 'label': 'Jardinagem'},
  ];

  final List<Map<String, dynamic>> ranking = [
    {'nome': 'Isaac', 'profissao': 'Pintor', 'pos': 1, 'foto': 'https://i.pravatar.cc/100?img=1'},
    {'nome': 'Eduardo', 'profissao': 'Mecânico', 'pos': 2, 'foto': 'https://i.pravatar.cc/100?img=2'},
    {'nome': 'Nathan', 'profissao': 'Encanador', 'pos': 3, 'foto': 'https://i.pravatar.cc/100?img=3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              SizedBox(height: 16),
              _buildBanner(),
              SizedBox(height: 16),
              _buildCategories(),
              SizedBox(height: 16),
              _buildRanking(),
              SizedBox(height: 16),
              _buildHelpButton(),
              SizedBox(height: 16),
              _buildCampaignBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Icon(Icons.menu),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            'Rua Bolsonaro, 22',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Icon(Icons.person_outline),
        SizedBox(width: 12),
        Icon(Icons.notifications_none),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Desconto Especial em Manutenção e Instalação de Ar-Condicionado!',
                    style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('HELP25',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 4),
                Text('Use e ganhe 15% OFF',
                    style: GoogleFonts.outfit(color: Colors.white70)),
              ],
            ),
          ),
          Image.network('https://i.imgur.com/nI8F8cL.png', height: 80),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12),
      itemBuilder: (context, index) {
        final item = categories[index];
        return Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.yellow[600],
              child: Icon(item['icon'], color: Colors.black),
            ),
            SizedBox(height: 6),
            Text(item['label'],
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        );
      },
    );
  }

  Widget _buildRanking() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_outlined, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Melhores Prestadores do Mês na sua Região!',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                final item = ranking[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(item['foto']),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text('${item['pos']}º',
                                  style: GoogleFonts.outfit(
                                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(item['nome'],
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(item['profissao'],
                          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHelpButton() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        ),
        onPressed: () {},
        icon: Icon(Icons.touch_app, color: Colors.black),
        label: Text('Solicitar um HELP',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }

  Widget _buildCampaignBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BANNER DE CAMPANHA',
                    style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                Text('CUPOM',
                    style: GoogleFonts.outfit(color: Colors.yellow[600], fontWeight: FontWeight.bold, fontSize: 20)),
                Text('Use e ganhe 15% OFF',
                    style: GoogleFonts.outfit(color: Colors.white70)),
              ],
            ),
          ),
          Image.network('https://i.imgur.com/nI8F8cL.png', height: 60),
        ],
      ),
    );
  }
} 
