import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:package1/package1.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculadora();
    final i = calculator.division([2, 0]);
    print(i);
    final operaciones = calculator.operacionesmultiples(['2', '+', '2']);
    print(operaciones);

    final wea = calculator.resta([-7, 1]);

    expect(calculator.suma([2, 3]), 5);
    String history = calculator.obtenerHistorial().join('\n');

    print("historial completo:");
    print(history);
  });
}
