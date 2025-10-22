import 'package:flutter/material.dart';
import 'package:package1/package1.dart';
import 'package:use_package/components/botones.dart';

class Packagescreen extends StatefulWidget {
  const Packagescreen({super.key});

  @override
  State<Packagescreen> createState() => _PackagescreenState();
}

class _PackagescreenState extends State<Packagescreen> {
  List<String> operacion = [];
  String numeroActual = '0';
  String displayString = '0';
  Calculadora calculator = Calculadora();
  bool mostrandoHistorial = false;
  String historialFormateado = '';
  bool esResultadoOError = false;

  void presionarNumero(String digito) {
    setState(() {
      mostrandoHistorial = false;
      if (esResultadoOError) {
        numeroActual = digito;
        displayString = digito;
        esResultadoOError = false;
      } else {
        if (numeroActual == '0') numeroActual = '';
        if (displayString == '0') displayString = '';
        numeroActual += digito;
        displayString += digito;
      }
    });
  }

  void presionarOperador(String op) {
    setState(() {
      mostrandoHistorial = false;
      if (esResultadoOError) {
        esResultadoOError = false;
      }
      if (numeroActual.isEmpty && operacion.isNotEmpty) {
        return;
      }
      operacion.add(numeroActual);
      operacion.add(op);
      numeroActual = '';
      displayString += op;
    });
  }

  void presionarIgual() {
    setState(() {
      mostrandoHistorial = false;
      if (numeroActual.isEmpty || operacion.isEmpty) return;
      operacion.add(numeroActual);

      try {
        double result = calculator.operacionesmultiples(operacion);
        displayString = result.toString();
        numeroActual = result.toString();
      } catch (e) {
        displayString = 'Error';
        numeroActual = '0';
      }
      operacion.clear();
      esResultadoOError = true;
    });
  }

  void presionarHistorial() {
    setState(() {
      if (mostrandoHistorial) {
        mostrandoHistorial = false;
      } else {
        historialFormateado = calculator.historial.join('\n');
        if (historialFormateado.isEmpty) {
          historialFormateado = 'No hay historial';
        }
        mostrandoHistorial = true;
      }
    });
  }

  void limpiarTodo() {
    setState(() {
      numeroActual = '0';
      displayString = '0';
      operacion.clear();
      mostrandoHistorial = false;
      esResultadoOError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(24),
              alignment: mostrandoHistorial
                  ? Alignment.topLeft
                  : Alignment.centerRight,
              child: mostrandoHistorial
                  ? SingleChildScrollView(
                      child: Text(
                        historialFormateado,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        displayString,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                      ),
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Botones(
                        icon: Text('C'),
                        color: Colors.white,
                        backgroundColor: Colors.redAccent,
                        onPressed: limpiarTodo,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: presionarHistorial,
                          icon: Icon(Icons.access_time),
                          color: Colors.white,
                          iconSize: 65,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                      Botones(
                        icon: Text('7'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('7'),
                      ),
                      Botones(
                        icon: Text('4'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('4'),
                      ),
                      Botones(
                        icon: Text('1'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('1'),
                      ),
                      Botones(
                        icon: Text('0'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('0'),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Botones(
                        icon: Text('8'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('8'),
                      ),
                      Botones(
                        icon: Text('5'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('5'),
                      ),
                      Botones(
                        icon: Text('2'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('2'),
                      ),
                      Botones(
                        icon: Text('.'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          setState(() {
                            if (!numeroActual.contains('.')) {
                              presionarNumero('.');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Botones(
                        icon: Text('9'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('9'),
                      ),
                      Botones(
                        icon: Text('6'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('6'),
                      ),
                      Botones(
                        icon: Text('3'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => presionarNumero('3'),
                      ),
                      Botones(
                        icon: Text('='),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: presionarIgual,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Botones(
                        icon: Text('/'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => presionarOperador('/'),
                      ),
                      Botones(
                        icon: Text('*'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => presionarOperador('*'),
                      ),
                      Botones(
                        icon: Text('+'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => presionarOperador('+'),
                      ),
                      Botones(
                        icon: Text('-'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => presionarOperador('-'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
