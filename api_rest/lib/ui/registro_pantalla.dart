import 'package:flutter/material.dart';
import '../logica/servicio_autenticacion.dart';

class PantallaRegistro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PantallaRegistroState();
}

class PantallaRegistroState extends State<PantallaRegistro> {
  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Variable de carga y servicio de autenticación
  bool _cargando = false;
  final ServicioAutenticacion _servicioAutenticacion = ServicioAutenticacion();

  // Método para manejar el registro de usuario
  void _registrarUsuario() async {
    final String nombre = _nombreController.text.trim();
    final String correo = _correoController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    // Validación de campos vacíos
    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
      _mostrarMensaje("Por favor, completa todos los campos.");
      return;
    }

    // Validación de formato del correo
    if (!_validarCorreo(correo)) {
      _mostrarMensaje("Ingresa un correo electrónico válido.");
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final bool exito =
      await _servicioAutenticacion.registrar(nombre, correo, contrasena);

      setState(() {
        _cargando = false;
      });

      if (exito) {
        _mostrarMensaje("Usuario registrado con éxito. Inicia sesión.");
        Navigator.pop(context);
      } else {
        _mostrarMensaje("Error al registrar el usuario.");
      }
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      _mostrarMensaje("Error inesperado: $e");
    }
  }

  // Método para validar el correo
  bool _validarCorreo(String correo) {
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(correo);
  }

  // Método para mostrar mensajes
  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Icono Circular del Usuario
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[100],
                  backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/74/74472.png',
                  ),
                ),
                SizedBox(height: 30),
                // Campo de nombre
                _campoTexto(
                  controlador: _nombreController,
                  etiqueta: 'Nombre',
                  esContrasena: false,
                ),
                SizedBox(height: 16),
                // Campo de correo
                _campoTexto(
                  controlador: _correoController,
                  etiqueta: 'Correo Electrónico',
                  esContrasena: false,
                ),
                SizedBox(height: 16),
                // Campo de contraseña
                _campoTexto(
                  controlador: _contrasenaController,
                  etiqueta: 'Contraseña',
                  esContrasena: true,
                ),
                SizedBox(height: 20),
                // Botón de registro
                _cargando
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Registrar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "¿Ya tienes cuenta? Inicia sesión aquí.",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controlador,
    required String etiqueta,
    required bool esContrasena,
  }) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: OutlineInputBorder(),
      ),
      obscureText: esContrasena,
    );
  }
}
