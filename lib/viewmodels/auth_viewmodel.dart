import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../utils/format_utils.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  bool _isLoggedIn = false;
  String? _userToken;
  String? _userRole;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userToken => _userToken;
  String? get userRole => _userRole;
  String? get userEmail => _userEmail;

  // Controllers para formulários
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? _selectedRole;

  String? get selectedRole => _selectedRole;

  void setSelectedRole(String? role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> login() async {
    await executeAsync(() async {
      final success = await AuthService.login(
        FormatUtils.formatEmail(emailController.text),
        passwordController.text,
      );

      if (success) {
        _userEmail = emailController.text.trim();
        _isLoggedIn = true;
        setSuccess('Login realizado com sucesso!');
        
        // Limpar campos
        emailController.clear();
        passwordController.clear();
      } else {
        throw Exception('Credenciais inválidas');
      }
    });
  }

  Future<void> register() async {
    await executeAsync(() async {
      final nameParts = FormatUtils.formatName(nameController.text).split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final success = await AuthService.register(
        firstName: firstName,
        lastName: lastName,
        email: FormatUtils.formatEmail(emailController.text),
        telephone: phoneController.text.trim(),
        hashPassword: passwordController.text,
        cpf: cpfController.text,
      );

      if (success) {
        setSuccess('Conta criada com sucesso!');
        
        // Limpar campos
        nameController.clear();
        cpfController.clear();
        phoneController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        throw Exception('Erro ao criar conta');
      }
    });
  }

  Future<void> checkLoginStatus() async {
    await executeAsync(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        _userToken = token;
        _isLoggedIn = true;
        _userEmail = prefs.getString('user_email');
      }
    });
  }

  Future<void> logout() async {
    await executeAsync(() async {
      await AuthService.logout();
      _isLoggedIn = false;
      _userToken = null;
      _userRole = null;
      _userEmail = null;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    cpfController.dispose();
    phoneController.dispose();
    super.dispose();
  }
} 