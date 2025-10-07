import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  // Si estás en web o iOS: usa http://localhost:3000

  Future<List<dynamic>> getUsuarios() async {
    final url = Uri.parse('$baseUrl/usuarios');
    final respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body);
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<String> register(
    String correo,
    String nombre,
    String fecha_nacimiento,
    String pais,
    String telefono,
    String contrasenia,
  ) async {
    final url = Uri.parse("$baseUrl/register");
    try {
      final respuesta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "correo": correo,
          "nombre": nombre,
          "fecha_nacimiento": fecha_nacimiento,
          "pais": pais,
          "telefono": telefono,
          "contraseña": contrasenia,
        }),
      );
      if (respuesta.statusCode == 200) {
        var data = jsonDecode(respuesta.body);
        return data['mensaje'];
      } else {
        return 'Error: ${respuesta.body}';
      }
    } catch (e) {
      return 'Error:${e.toString()}';
    }
  }

  Future<bool> search(String email) async {
    final url = Uri.parse("$baseUrl/search/$email");
    try {
      final respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return true;
    }
  }

  Future<String> login(String correo, String contrasenia) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      final respuesta = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, "contraseña": contrasenia}),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => http.Response('{"mesaje":"Error: Timeout"}', 408),
          );

      if (respuesta.statusCode == 200) {
        var data = jsonDecode(respuesta.body);
        return data['mensaje']?.toString() ?? 'Error desconocido';
      } else {
        return 'Error: ${respuesta.body}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> changePassword(String correo, String contrasenia) async {
    final url = Uri.parse("$baseUrl/change-password");
    try {
      final respuesta = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contraseña': contrasenia, "correo": correo}),
      );
      if (respuesta.statusCode == 400) {
        return "La nueva contraseña no puede ser igual a la anterior";
      } else if (respuesta.statusCode == 500) {
        return "Error al cambiar contraseña";
      } else if (respuesta.statusCode == 404) {
        return "Usuario no encontrado";
      } else {
        return "Contraseña Cambiada";
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
