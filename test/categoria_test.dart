import 'package:flutter_test/flutter_test.dart';
import 'package:dou_um_help_flutter/Screens/Pages/home.dart'; 

void main() {
  test('Categoria.fromJson deve criar uma instância corretamente', () {
    final json = {
      'id': '123',
      'name': 'Elétrica',
    };

    final categoria = Categoria.fromJson(json);

    expect(categoria.id, '123');
    expect(categoria.name, 'Elétrica');
  });
}
