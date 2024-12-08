import 'package:flutter/material.dart';
import 'ui/login_pantalla.dart';
import 'ui/crudprotegido_pantalla.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      initialRoute: '/login',
      routes: {
        '/login': (context) => PantallaInicioSesion(),
        '/protected': (context) => PantallaProtegida(),
      },
    );
  }
}
