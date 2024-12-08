import 'dart:convert';
import 'package:http/http.dart' as http;
import 'servicio_autenticacion.dart';

class ServicioCrud {
  final String baseUrl = "http://192.168.1.7:81/api_usuario/index.php";
  final ServicioAutenticacion _servicioAutenticacion = ServicioAutenticacion();

  Future<List<dynamic>> obtenerUsuarios() async {
    final url = Uri.parse("$baseUrl?accion=obtenerTodos");
    final token = await _servicioAutenticacion.obtenerToken();

    // Imprimir para verificar URL y token
    print("URL: $url");
    print("Token: $token");

    try {
      final respuesta = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Imprimir para verificar la respuesta
      print("Estado de la respuesta: ${respuesta.statusCode}");
      print("Encabezados de la respuesta: ${respuesta.headers}");
      print("Cuerpo de la respuesta: ${respuesta.body}");

      if (respuesta.statusCode == 200) {
        return jsonDecode(respuesta.body);
      } else {
        // Lanzar una excepción con más información para depuración
        throw Exception("Error ${respuesta.statusCode}: ${respuesta.body}");
      }
    } catch (e) {
      print("Excepción: $e");
      rethrow;
    }
  }

  Future<bool> crearUsuario(String nombre, String correo, String contrasena) async {
    final url = Uri.parse("$baseUrl?accion=registrar");
    try {
      final respuesta = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "correo": correo,
          "contrasena": contrasena,
        }),
      );

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 200 && datos['mensaje'] != null) {
        return true; // Usuario creado exitosamente
      } else if (datos['error'] != null) {
        throw Exception(datos['error']); // Error específico del backend
      }
    } catch (e) {
      print("Error al crear usuario: $e");
      rethrow; // Lanza el error para manejarlo en la interfaz
    }
    return false;
  }

  Future<bool> actualizarUsuario(int id, String nombre, String correo) async {
    final url = Uri.parse("$baseUrl?accion=actualizar");
    final token = await _servicioAutenticacion.obtenerToken();

    if (token == null) {
      throw Exception("Token no proporcionado.");
    }

    print("Token para actualizar usuario: $token");

    try {
      final respuesta = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id": id,
          "nombre": nombre,
          "correo": correo,
        }),
      );

      final datos = jsonDecode(respuesta.body);

      if (respuesta.statusCode == 200 && datos['mensaje'] != null) {
        return true; // Usuario actualizado exitosamente
      } else if (datos['error'] != null) {
        throw Exception(datos['error']);
      }
    } catch (e) {
      print("Error al actualizar usuario: $e");
      rethrow;
    }
    return false;
  }
  Future<bool> eliminarUsuario(int id) async {
    final url = Uri.parse("$baseUrl?accion=eliminar");
    final token = await _servicioAutenticacion.obtenerToken();

    print("URL: $url");
    print("Token: $token");

    try {
      final respuesta = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": id}),
      );

      print("Estado de la respuesta: ${respuesta.statusCode}");
      print("Cuerpo de la respuesta: ${respuesta.body}");

      return respuesta.statusCode == 200;
    } catch (e) {
      print("Excepción: $e");
      return false;
    }
  }
}
