import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dou_um_help_flutter/Screens/Pages/home.dart'; 

void main() {
  group('getIconForCategory', () {
    test('deve retornar o ícone correto para categorias conhecidas', () {
      expect(getIconForCategory('elétrica'), Icons.flash_on);
      expect(getIconForCategory('pinturas'), Icons.format_paint);
      expect(getIconForCategory('pets'), Icons.pets);
    });

    test('deve retornar o ícone padrão para categoria desconhecida', () {
      expect(getIconForCategory('Aleatória'), Icons.category);
    });
  });
}
