import 'package:AppPro/View/Inventario.dart';
import 'package:AppPro/View/Rest.dart';
import 'package:AppPro/View/Clima.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class Invitados extends StatefulWidget {
  final String nombre;
  const Invitados(this.nombre, {super.key});
  @override
  InvitadosApp createState() => InvitadosApp();
}

class InvitadosApp extends State<Invitados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('☺ Invitado ➡ ${widget.nombre}'),
        automaticallyImplyLeading: false, //Borrar flecha atras
        backgroundColor: const Color(0xff8BC34A),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    //Margen a los lados
                    top: 60,
                    left: 10,
                    right: 10),
                child: SizedBox(
                  //Dimensiones internas contenedor
                  width: 300,
                  height: 300,
                  child: Image.asset('img/Invitado.gif'),
                ),
              ),
              /*Padding(
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
              ),*/
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Rest()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 150, 62),
                  ),
                  child: const Text('JSON Placeholder'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Clima()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 49, 112),
                  ),
                  child: const Text('🌤 Clima'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Inventario(widget.nombre)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff009688),
                  ),
                  child: const Text('Inventario'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 6, 6),
                  ),
                  child: const Text('Salir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
