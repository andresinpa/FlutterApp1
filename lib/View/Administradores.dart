import 'package:flutter/material.dart';
import '../DTO/User.dart';
import '../main.dart';

class Administradores extends StatefulWidget {
  final String nombre;
  Administradores(this.nombre);
  @override
  AdministradoresApp createState() => AdministradoresApp();
}

class AdministradoresApp extends State<Administradores> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('😎 Administrador ➡ ' + widget.nombre),
        automaticallyImplyLeading: false, //Borrar flecha atras
        backgroundColor: Color(0xff4CAF50),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                //Margen a los lados
                  top: 60,
                  left: 10,
                  right: 10),
              child: Container(
                //Dimensiones internas contenedor
                width: 400,
                height: 400,
                child: Image.asset('img/Administrador.gif'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MyApp()));
                },
                child: Text('Salir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff009688),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
