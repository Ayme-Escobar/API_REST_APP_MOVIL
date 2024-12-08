import 'package:flutter/material.dart';
import '../logica/servicio_crud.dart';
import '../logica/servicio_autenticacion.dart';

class PantallaProtegida extends StatefulWidget {
  @override
  _PantallaProtegidaState createState() => _PantallaProtegidaState();
}

class _PantallaProtegidaState extends State<PantallaProtegida> {
  final ServicioCrud _servicioCrud = ServicioCrud();
  final ServicioAutenticacion _servicioAutenticacion = ServicioAutenticacion();

  List<dynamic> _usuarios = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _obtenerUsuarios();
  }

  void _obtenerUsuarios() async {
    setState(() {
      _cargando = true;
    });

    try {
      final usuarios = await _servicioCrud.obtenerUsuarios();
      setState(() {
        _usuarios = usuarios;
      });
    } catch (e) {
      _mostrarSnackBar("Error al cargar los usuarios: $e", Colors.red);
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  bool _validarCorreo(String correo) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(correo);
  }

  void _crearUsuario(String nombre, String correo, String contrasena) async {
    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
      _mostrarSnackBar("Todos los campos son obligatorios.", Colors.red);
      return;
    }

    if (!_validarCorreo(correo)) {
      _mostrarSnackBar("El correo ingresado no es válido.", Colors.red);
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final exito = await _servicioCrud.crearUsuario(nombre, correo, contrasena);
      if (exito) {
        _obtenerUsuarios();
        _mostrarSnackBar("Usuario creado con éxito.", Colors.green);
      } else {
        _mostrarSnackBar("Error al crear el usuario.", Colors.red);
      }
    } catch (e) {
      final mensajeError = e.toString().replaceFirst("Exception: ", "");
      _mostrarSnackBar(mensajeError, Colors.red);
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  void _actualizarUsuario(int id, String nombre, String correo) async {
    if (nombre.isEmpty || correo.isEmpty) {
      _mostrarSnackBar("Todos los campos son obligatorios.", Colors.red);
      return;
    }

    if (!_validarCorreo(correo)) {
      _mostrarSnackBar("El correo ingresado no es válido.", Colors.red);
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final exito = await _servicioCrud.actualizarUsuario(id, nombre, correo);
      if (exito) {
        _obtenerUsuarios();
        _mostrarSnackBar("Usuario actualizado con éxito.", Colors.green);
      } else {
        _mostrarSnackBar("Error al actualizar el usuario.", Colors.red);
      }
    } catch (e) {
      final mensajeError = e.toString().replaceFirst("Exception: ", "");
      _mostrarSnackBar(mensajeError, Colors.red);
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarFormularioCrearUsuario() {
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _correoController = TextEditingController();
    final TextEditingController _contrasenaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Crear Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(labelText: "Correo Electrónico"),
              ),
              TextField(
                controller: _contrasenaController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _crearUsuario(
                  _nombreController.text.trim(),
                  _correoController.text.trim(),
                  _contrasenaController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioActualizarUsuario(dynamic usuario) {
    final TextEditingController _nombreController =
    TextEditingController(text: usuario['nombre']);
    final TextEditingController _correoController =
    TextEditingController(text: usuario['correo']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Actualizar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(labelText: "Correo Electrónico"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _actualizarUsuario(
                  usuario['id'],
                  _nombreController.text.trim(),
                  _correoController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestión de Usuarios",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _servicioAutenticacion.cerrarSesion();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // Espaciado inferior
                child: Text(
                  "Lista de Usuarios",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: _cargando
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = _usuarios[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/74/74472.png",
                          ),
                        ),
                        title: Text(
                          usuario['nombre'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(usuario['correo']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _mostrarFormularioActualizarUsuario(
                                      usuario),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _servicioCrud
                                    .eliminarUsuario(usuario['id']);
                                _obtenerUsuarios();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioCrearUsuario,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
