import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/format_utils.dart';
import 'login_screen.dart';
import 'success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _buttonPressed = false;
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
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
                          _buildTextField(authViewModel.nameController, 'Nome', Icons.person, true),
                          _buildTextField(authViewModel.cpfController, 'CPF', Icons.badge, true, isCpf: true),
                          _buildTextField(authViewModel.phoneController, 'Digite seu telefone (opcional)', Icons.phone, false, isPhone: true),
                          _buildTextField(authViewModel.emailController, 'Digite seu e-mail', Icons.email, true, email: true),
                          _buildPasswordField(authViewModel.passwordController, 'Digite sua senha'),
                          _buildPasswordField(_confirmPasswordController, 'Confirme sua senha', confirm: true),
                        ],
                      ),
                  ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
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
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await authViewModel.register();
                          if (authViewModel.successMessage != null && mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SuccessScreen()),
                            );
                          }
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        decoration: BoxDecoration(
                          color: _buttonPressed ? Colors.yellow[600] : Colors.yellow[700],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool required, {bool email = false, bool isCpf = false, bool isPhone = false}) {
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
              keyboardType: email ? TextInputType.emailAddress : 
                           isCpf || isPhone ? TextInputType.number : TextInputType.text,
              inputFormatters: isCpf ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ] : isPhone ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ] : null,
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
              onChanged: (value) {
                if (isCpf && value.length == 11) {
                  final formattedCpf = FormatUtils.formatCpf(value);
                  controller.text = formattedCpf;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: formattedCpf.length),
                  );
                } else if (isPhone && value.length == 11) {
                  final formattedPhone = FormatUtils.formatPhone(value);
                  controller.text = formattedPhone;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: formattedPhone.length),
                  );
                }
              },
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
            hint + ' *',
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
              obscureText: confirm ? !_confirmPasswordVisible : !_passwordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                hintText: hint,
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    confirm ? (_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                           : (_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (confirm) {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      } else {
                        _passwordVisible = !_passwordVisible;
                      }
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                }
                if (confirm && value != _confirmPasswordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }
} 