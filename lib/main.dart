import 'package:flutter/material.dart';
import './Screens/Pages/login.dart'; 

void main(List<String> args) {
  final env = args.isNotEmpty ? args[0] : 'prod';
  runApp(MyApp(env: env));
}

class MyApp extends StatelessWidget {
    final String env;

  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    print('Ambiente atual: $env');
    return MaterialApp(
      title: 'Douum Help',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const LoginScreen(),
    );
  }
}
