import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _buttonPressed = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Processar os dados do formulário
      Navigator.pushNamed(context, '/sign_2', arguments: {
        'name': nameController.text,
        'surname': surnameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'password': passwordController.text,
      });
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
                      _buildTextField(surnameController, 'Sobrenome', Icons.person, true),
                      _buildTextField(phoneController, 'Digite seu telefone (opcional)', Icons.phone, false),
                      _buildTextField(emailController, 'Digite seu e-mail', Icons.email, true, email: true),
                      _buildPasswordField(passwordController, 'Digite sua senha'),
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
      child: TextFormField(
        controller: controller,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: required
            ? (value) => value!.isEmpty ? 'Campo obrigatório' : null
            : null,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, {bool confirm = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Campo obrigatório';
          if (confirm && value != passwordController.text) return 'As senhas não coincidem';
          return null;
        },
      ),
    );
  }
}
