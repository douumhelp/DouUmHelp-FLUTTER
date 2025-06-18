import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Removida verificação automática de status de login
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Removida verificação automática de redirecionamento

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Logo não encontrada", style: GoogleFonts.outfit(color: Colors.red));
                  },
                ),
                    SizedBox(height: 20),
                Text(
                  'Bem-vindo!',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                    SizedBox(height: 8),
                Text(
                  'Acesse sua conta para continuar e aproveitar todas as funcionalidades.🛠️',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                    SizedBox(height: 20),
                    _buildTextField('Email', authViewModel.emailController, Icons.email, false),
                    SizedBox(height: 10),
                    _buildTextField('Senha', authViewModel.passwordController, Icons.lock, true),
                    SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implementar recuperação de senha
                    },
                    child: Text(
                      'Esqueceu a sua senha?',
                      style: GoogleFonts.outfit(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                    SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFACC15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    ),
                      onPressed: authViewModel.isLoading ? null : () async {
                        await authViewModel.login();
                        if (authViewModel.isLoggedIn && mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child: authViewModel.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : Text(
                      'Entrar',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                    SizedBox(height: 20),
                Text(
                  'Não tem conta?',
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Crie agora!',
                    style: GoogleFonts.outfit(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                        ),
                      ),
                    ),
                    
                    // Mensagens de erro/sucesso
                    if (authViewModel.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          authViewModel.errorMessage!,
                          style: GoogleFonts.outfit(
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    
                    if (authViewModel.successMessage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          authViewModel.successMessage!,
                          style: GoogleFonts.outfit(
                            color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, bool isPassword) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
      controller: controller,
        obscureText: isPassword && !_passwordVisible,
        keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        ),
      ),
    );
  }
} 