import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServicioAutenticacion {
  final String baseUrl = "http://192.168.1.7:81/api_usuario/index.php";

  Future<bool> iniciarSesion(String correo, String contrasena) async {
    final url = Uri.parse("$baseUrl?accion=iniciarSesion");
    print("URL de inicio de sesión: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo, "contrasena": contrasena}),
      );

      print("Estado de la respuesta de inicio de sesión: ${response.statusCode}");
      print("Cuerpo de la respuesta de inicio de sesión: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwtToken', data['token']);

          // Imprimir el token al momento de guardarlo
          print("Token guardado: ${data['token']}");
          return true;
        }
      }
    } catch (e) {
      print("Excepción en inicio de sesión: $e");
    }

    return false;
  }

  Future<bool> registrar(String nombre, String correo, String contrasena) async {
    final url = Uri.parse("$baseUrl?accion=registrar");
    print("URL de registro: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "correo": correo,
          "contrasena": contrasena,
        }),
      );

      print("Estado de la respuesta de registro: ${response.statusCode}");
      print("Cuerpo de la respuesta de registro: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['mensaje'] != null) {
          print("Registro exitoso: ${data['mensaje']}");
          return true;
        } else if (data['error'] != null) {
          print("Error en registro: ${data['error']}");
        }
      }
    } catch (e) {
      print("Excepción en registro: $e");
    }

    return false;
  }

  Future<String?> obtenerToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      // Imprimir el token cuando se recupera
      print("Token recuperado: $token");
      return token;
    } catch (e) {
      print("Excepción al obtener el token: $e");
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwtToken');

      // Confirmar que el token se eliminó
      print("Token eliminado");
    } catch (e) {
      print("Excepción al cerrar sesión: $e");
    }
  }
}
