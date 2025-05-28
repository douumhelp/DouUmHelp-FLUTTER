import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class TermsScreen extends StatelessWidget {
  final Map<String, String> userData;

  const TermsScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Termos e Condições',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '''
Termos e Condições de Uso do Dou um Help

1. Aceitação dos Termos
Ao utilizar o aplicativo Dou um Help, você concorda com estes termos e condições de uso. Se você não concordar com algum dos termos, não utilize o aplicativo.

2. Uso do Serviço
2.1. O Dou um Help é uma plataforma que conecta pessoas que precisam de ajuda com prestadores de serviços.
2.2. Os usuários devem fornecer informações verdadeiras e manter seus dados atualizados.
2.3. É proibido o uso do aplicativo para fins ilegais ou não autorizados.

3. Privacidade e Dados Pessoais
3.1. Coletamos e processamos dados pessoais conforme nossa Política de Privacidade.
3.2. Seus dados serão protegidos e utilizados apenas para os fins especificados.

4. Responsabilidades
4.1. O usuário é responsável por todas as atividades realizadas em sua conta.
4.2. O Dou um Help não se responsabiliza por danos indiretos decorrentes do uso do serviço.

5. Alterações nos Termos
5.1. Podemos alterar estes termos a qualquer momento.
5.2. Alterações significativas serão comunicadas aos usuários.

6. Encerramento
6.1. Você pode encerrar sua conta a qualquer momento.
6.2. Podemos encerrar ou suspender contas que violem estes termos.
                    ''',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFACC15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _handleAcceptTerms(context),
                child: Text(
                  'Aceitar e Criar Conta',
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Recusar',
                  style: GoogleFonts.outfit(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAcceptTerms(BuildContext context) async {
    try {
      final success = await AuthService.register(
        firstName: userData['firstName']!,
        lastName: userData['lastName']!,
        email: userData['email']!,
        telephone: userData['telephone']!,
        hashPassword: userData['hashPassword']!,
        cpf: userData['cpf']!,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar conta'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar conta'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
} 