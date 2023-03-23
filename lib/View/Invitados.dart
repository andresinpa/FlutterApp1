import 'package:flutter/material.dart';
import 'package:project0/main.dart';

class Bienvenida extends StatefulWidget {
  @override
  BienvenidaApp createState() => BienvenidaApp();
}

class BienvenidaApp extends State<Bienvenida> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenida'),
        automaticallyImplyLeading: false, //Borrar flecha atras
        backgroundColor: Color(0xff0E5589),
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
                child: Image.asset('img/bienvenida.gif'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
