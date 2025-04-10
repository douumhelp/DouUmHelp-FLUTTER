import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'terms.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerUser({
  required String name,
  required String lastName,
  required String email,
  required String hashpassword,
}) async {
  final url = Uri.parse('https://api.douumhelp.com.br/auth/register/pf');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'firstName': String,
      'lastName': String,
      'email': String,
      'hashPassword': String,
      'telephone': String,
      'cpf': String,
    }),
  );

  if (response.statusCode == 201) {
    print(' Cadastro realizado com sucesso!');
    // Aqui você pode navegar para a próxima tela (ex: login ou home)
  } else {
    print(' Erro ao cadastrar: ${response.body}');
    // Mostrar erro na tela, se quiser
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _buttonPressed = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController hashPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

    final name = nameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final phone = telephoneController.text;
    final hashpassword = hashPasswordController.text;

      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Terms(
          name: name,
          lastName: lastName,
          phone: phone,
          email: email,
          hashpassword: hashpassword,
        ),
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Image.asset('assets/logo.png', width: 300, height: 150),
                Text(
                  'Crie sua conta',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Insira seus dados para começar',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(nameController, 'Nome', Icons.person, true),
                      _buildTextField(lastNameController, 'Sobrenome', Icons.person, true),
                      _buildTextField(telephoneController, 'Digite seu telefone (opcional)', Icons.phone, false),
                      _buildTextField(emailController, 'Digite seu e-mail', Icons.email, true, email: true),
                      _buildPasswordField(hashPasswordController, 'Digite sua senha'),
                      _buildPasswordField(confirmPasswordController, 'Confirme sua senha', confirm: true),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    'Já possui uma conta? Faça login',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTapDown: (_) => setState(() => _buttonPressed = true),
                  onTapUp: (_) => setState(() => _buttonPressed = false),
                  onTap: _submitForm,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      color: _buttonPressed ? Colors.yellow[600] : Colors.yellow[700],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Próximo',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool required, {bool email = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint + (required ? ' *' : ''),
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.grey),
                hintText: hint,
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              validator: required
                  ? (value) => value!.isEmpty ? 'Campo obrigatório' : null
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, {bool confirm = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$hint *',
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              validator: (value) {
                if (value!.isEmpty) return 'Campo obrigatório';
                if (confirm && value != hashPasswordController.text) return 'As senhas não coincidem';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
