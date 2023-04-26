import 'package:AppPro/View/Geoposition.dart';
import 'package:AppPro/View/Rest.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'Registro.dart';

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
      body: SingleChildScrollView(
        child: Center(
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
                  width: 300,
                  height: 300,
                  child: Image.asset('img/Invitado.gif'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Geoposition()));
                  },
                  child: Text('Mi Ubicación'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff009688),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Rest()));
                  },
                  child: Text('REST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff009688),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
