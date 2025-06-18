import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';



class Terms extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String telephone;
  final String email;
  final String hashPassword;

  const Terms({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.email,
    required this.hashPassword,
  }) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {

  String termo = '';
  bool loading = true;

  bool aceitoTermos = false;
  final TextEditingController _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cpfController = TextEditingController();
  bool isLoading = false;
  String? message;

  @override
  void initState() {
  super.initState();
  carregarTermo();
}


    Future<void> registerUser() async {
      print('Chamou registerUser()');
    setState(() {
      isLoading = true;
      message = null;
    });

    final url = Uri.parse('https://api-production-d036.up.railway.app/auth/register/pf');
    
    // Limpar CPF (remover pontos e traços)
    final cpf = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');

    final body = {
      'firstName': widget.firstName,
      'lastName': widget.lastName,
      'telephone': widget.telephone,
      'email': widget.email,
      'hashPassword': widget.hashPassword,
      'cpf': cpf,
      'role': 'pf',
    };

    print('Enviando dados para cadastro: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        setState(() {
          message = 'Usuário cadastrado com sucesso!';
        });
      } else {
        setState(() {
          message = 'Erro ao cadastrar: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      print('Erro na requisição: $e');
      setState(() {
        message = 'Erro de conexão: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      registerUser();
    }
  }

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void _submitForm() async {
    print('Clicou no botão continuar');
    
    // Validar CPF
    final cpf = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cpf.isEmpty || cpf.length != 11) {
      _showMessage('Por favor, preencha um CPF válido (11 dígitos)');
      return;
    }

    if (!aceitoTermos) {
      _showMessage('Você precisa aceitar os Termos e Condições');
      return;
    }

    await registerUser(); 

    if (message == 'Usuário cadastrado com sucesso!') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _showMessage(message ?? 'Erro desconhecido');
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

    Future<void> carregarTermo() async {
    final texto = await rootBundle.loadString('assets/Termos/termo_de_uso.txt');
    setState(() {
      termo = texto;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.arrow_circle_right, color: Color(0xFFFACC15), size: 32),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Apenas mais um\npasso para terminar\nsua conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'CPF (Campo obrigatório)',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(    
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFd1d5db)),
                ),
                child: TextField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfMaskFormatter],
                  decoration: const InputDecoration(
                    hintText: 'Digite seu CPF',
                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFd1d5db)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Termos e Condições',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                      loading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: 150, // ajuste como preferir
                              child: SingleChildScrollView(
                                child: Text(
                                  termo,
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: aceitoTermos,
                    onChanged: (value) {
                      setState(() {
                        aceitoTermos = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Estou Ciente e Aceito os Termos e Condições da Empresa',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFACC15),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}