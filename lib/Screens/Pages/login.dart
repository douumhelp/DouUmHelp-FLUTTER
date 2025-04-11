import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';       
import 'register.dart';   
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _hashPasswordController = TextEditingController();
  bool _passwordVisible = false;

   Future<void> loginUser(BuildContext context) async {
  final input = _inputController.text.trim();
  final hashPassword = _hashPasswordController.text;

  if (input.isEmpty || hashPassword.isEmpty) {
    _showMessage('Preencha todos os campos');
    return;
  }

  final url = Uri.parse('https://api.douumhelp.com.br/auth/login');

  final isCpf = RegExp(r'^\d{11}$').hasMatch(input); // verifica se são 11 dígitos
  final body = {
    if (isCpf) 'cpf': input else 'email': input,
    'hashPassword': hashPassword,
  };

  debugPrint('Enviando login com corpo: $body');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Enviando login com corpo: $body');
    print('Resposta: ${response.statusCode} ${response.body}');


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      if (token != null) {
       final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
       );
      }else {
        _showMessage('Token não encontrado na resposta.');
      }
    } else {
      _showMessage('Erro ao fazer login: ${response.statusCode}');
    }
  } catch (e) {
    _showMessage('Erro de conexão: $e');
  }
}

void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
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
                _buildTextField('Email', _inputController, Icons.email, false),
                SizedBox(height: 10),
                _buildTextField('Senha', _hashPasswordController, Icons.lock, true),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // ação de esqueci a senha
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
                  onPressed: () {
                    loginUser(context);
                  },
                  child: Text(
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
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisible : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Color(0xFFFACC15), width: 2),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
