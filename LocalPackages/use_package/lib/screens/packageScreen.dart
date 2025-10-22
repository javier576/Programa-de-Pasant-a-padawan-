import 'package:flutter/material.dart';
import 'package:package1/package1.dart';
import 'package:use_package/components/botones.dart';

class Packagescreen extends StatefulWidget {
  const Packagescreen({super.key});

  @override
  State<Packagescreen> createState() => _PackagescreenState();
}

class _PackagescreenState extends State<Packagescreen> {
  List<String> _operacion = [];
  String _numeroActual = '0';
  String _displayString = '0';
  Calculadora _calculator = Calculadora();
  bool _mostrandoHistorial = false;
  String _historialFormateado = '';
  bool _esResultadoOError = false;

  void _presionarNumero(String digito) {
    setState(() {
      _mostrandoHistorial = false;
      if (_esResultadoOError) {
        _numeroActual = digito;
        _displayString = digito;
        _esResultadoOError = false;
      } else {
        if (_numeroActual == '0') _numeroActual = '';
        if (_displayString == '0') _displayString = '';
        _numeroActual += digito;
        _displayString += digito;
      }
    });
  }

  void _presionarOperador(String op) {
    setState(() {
      _mostrandoHistorial = false;
      if (_esResultadoOError) {
        _esResultadoOError = false;
      }
      if (_numeroActual.isEmpty && _operacion.isNotEmpty) {
        return;
      }
      _operacion.add(_numeroActual);
      _operacion.add(op);
      _numeroActual = '';
      _displayString += op;
    });
  }

  void _presionarIgual() {
    setState(() {
      _mostrandoHistorial = false;
      if (_numeroActual.isEmpty || _operacion.isEmpty) return;
      _operacion.add(_numeroActual);

      try {
        double result = _calculator.operacionesmultiples(_operacion);
        _displayString = result.toString();
        _numeroActual = result.toString();
      } catch (e) {
        _displayString = 'Error';
        _numeroActual = '0';
      }
      _operacion.clear();
      _esResultadoOError = true;
    });
  }

  void _presionarHistorial() {
    setState(() {
      if (_mostrandoHistorial) {
        _mostrandoHistorial = false;
      } else {
        _historialFormateado = _calculator.historial.join('\n');
        if (_historialFormateado.isEmpty) {
          _historialFormateado = 'No hay historial';
        }
        _mostrandoHistorial = true;
      }
    });
  }

  void _limpiarTodo() {
    setState(() {
      _numeroActual = '0';
      _displayString = '0';
      _operacion.clear();
      _mostrandoHistorial = false;
      _esResultadoOError = false;
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
              alignment: _mostrandoHistorial
                  ? Alignment.topLeft
                  : Alignment.centerRight,
              child: _mostrandoHistorial
                  ? SingleChildScrollView(
                      child: Text(
                        _historialFormateado,
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
                        _displayString,
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
                        onPressed: _limpiarTodo,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: _presionarHistorial,
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
                        onPressed: () => _presionarNumero('7'),
                      ),
                      Botones(
                        icon: Text('4'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('4'),
                      ),
                      Botones(
                        icon: Text('1'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('1'),
                      ),
                      Botones(
                        icon: Text('0'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('0'),
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
                        onPressed: () => _presionarNumero('8'),
                      ),
                      Botones(
                        icon: Text('5'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('5'),
                      ),
                      Botones(
                        icon: Text('2'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('2'),
                      ),
                      Botones(
                        icon: Text('.'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          setState(() {
                            if (!_numeroActual.contains('.')) {
                              _presionarNumero('.');
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
                        onPressed: () => _presionarNumero('9'),
                      ),
                      Botones(
                        icon: Text('6'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('6'),
                      ),
                      Botones(
                        icon: Text('3'),
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: () => _presionarNumero('3'),
                      ),
                      Botones(
                        icon: Text('='),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: _presionarIgual,
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
                        onPressed: () => _presionarOperador('/'),
                      ),
                      Botones(
                        icon: Text('*'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => _presionarOperador('*'),
                      ),
                      Botones(
                        icon: Text('+'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => _presionarOperador('+'),
                      ),
                      Botones(
                        icon: Text('-'),
                        color: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        onPressed: () => _presionarOperador('-'),
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
