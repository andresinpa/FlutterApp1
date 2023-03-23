import 'package:flutter/material.dart';
import '../main.dart';

class Invitados extends StatefulWidget {
  final String nombre;
  Invitados(this.nombre);
  @override
  InvitadosApp createState() => InvitadosApp();
}

class InvitadosApp extends State<Invitados> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('☺ Invitado ➡ ' + widget.nombre),
        automaticallyImplyLeading: false, //Borrar flecha atras
        backgroundColor: Color(0xff8BC34A),
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
                child: Image.asset('img/Invitado.gif'),
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
