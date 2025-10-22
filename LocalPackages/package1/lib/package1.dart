import 'dart:math';

/// una Calculadora.
class Calculadora {
  int suma(List<int> numeros) {
    if (numeros.isEmpty) return 0;
    int resultado = 0;
    String operacion = numeros.join(' + ');
    for (var numero in numeros) {
      resultado += numero;
    }
    operacion += ' = $resultado';
    agregarOperacion(operacion);

    return resultado;
  }

  double resta(List<num> numeros) {
    if (numeros.isEmpty) return 0;
    String operacion = numeros.join(' - ');
    double resultado = numeros.first.toDouble();
    for (var numero in numeros.skip(1)) {
      resultado -= numero;
    }
    operacion += ' = $resultado';
    agregarOperacion(operacion);
    return resultado;
  }

  double multiplicacion(List<num> numeros) {
    if (numeros.isEmpty) return 0;
    String operacion = numeros.join(' * ');
    double resultado = 1;
    for (var numero in numeros) {
      resultado *= numero;
    }
    operacion += ' = $resultado';
    agregarOperacion(operacion);
    return resultado;
  }

  double division(List<num> numeros) {
    if (numeros.isEmpty) return 0;
    String operacion = numeros.join(' / ');
    double resultado = numeros.first.toDouble();
    for (var numero in numeros.skip(1)) {
      resultado /= numero;
    }
    operacion += ' = $resultado';
    agregarOperacion(operacion);
    return resultado;
  }

  //multiples operaciones
  double operacionesmultiples(List<String> operaciones) {
    double resultado = 0;
    double resultadoFinal = 0;
    double n1 = 0;
    double n2 = 0;
    String operacion = operaciones.join(' ');
    if (operaciones.isEmpty || operaciones.length < 3 || operaciones[0] == "") {
      print("Invalid operation format.");
      return resultadoFinal;
    }

    //multiplicacion
    while (operaciones.contains('*') || operaciones.contains('/')) {
      for (int operacion = 0; operacion < operaciones.length; operacion++) {
        if (operaciones[operacion] == "*") {
          n1 = double.parse(operaciones[operacion - 1]);
          n2 = double.parse(operaciones[operacion + 1]);
          double resultado = n1 * n2;

          operaciones.removeAt(operacion + 1);
          operaciones.removeAt(operacion);
          operaciones.removeAt(operacion - 1);
          operaciones.insert(operacion - 1, resultado.toString());
          resultadoFinal = double.parse(operaciones[0]);
        } else if (operaciones[operacion] == "/") {
          double n1 = double.parse(operaciones[operacion - 1]);
          double n2 = double.parse(operaciones[operacion + 1]);
          if (n2 == 0) {
            print("Division by zero is not allowed.");
            agregarOperacion("$operacion = Error: Division by zero");
            break;
          }
          double resultado = n1 / n2;

          operaciones.removeAt(operacion + 1);
          operaciones.removeAt(operacion);
          operaciones.removeAt(operacion - 1);
          operaciones.insert(operacion - 1, resultado.toString());
          resultadoFinal = double.parse(operaciones[0]);
        }
      }
    }

    // suma
    while (operaciones.contains('+') || operaciones.contains('-')) {
      for (int operacion = 0; operacion < operaciones.length; operacion++) {
        if (operaciones[operacion] == '+') {
          double n1 = double.parse(operaciones[operacion - 1]);
          double n2 = double.parse(operaciones[operacion + 1]);
          double resultado = n1 + n2;

          operaciones.removeAt(operacion + 1);
          operaciones.removeAt(operacion);
          operaciones.removeAt(operacion - 1);
          operaciones.insert(operacion - 1, resultado.toString());
          resultadoFinal = double.parse(operaciones[0]);
        } else if (operaciones[operacion] == '-') {
          double n1 = double.parse(operaciones[operacion - 1]);
          double n2 = double.parse(operaciones[operacion + 1]);
          double resultado = n1 - n2;

          operaciones.removeAt(operacion + 1);
          operaciones.removeAt(operacion);
          operaciones.removeAt(operacion - 1);
          operaciones.insert(operacion - 1, resultado.toString());
          resultadoFinal = double.parse(operaciones[0]);
        }
      }
    }

    operacion += ' = $resultadoFinal';
    agregarOperacion(operacion);
    return resultadoFinal;
  }

  List<String> historial = [];

  void agregarOperacion(String operacion) {
    historial.add(operacion);
  }

  List<String> obtenerHistorial() {
    return historial;
  }
}
