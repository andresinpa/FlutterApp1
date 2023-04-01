import 'package:AppPro/DTO/Token.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//librerias para usar crypto
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../DTO/User.dart'; //para el método utf8.encode

class Registro extends StatefulWidget {
  final User cadena;
  Registro(this.cadena); //recepcion de la variable
  @override
  RegistroApp createState() => RegistroApp();
}

void mensaje(BuildContext context, String titulo, String contenido,
        Function navegacion) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  navegacion(context);
                },
                child: Text('Aceptar')),
          ],
        );
      },
    );

class RegistroApp extends State<Registro> {
  TextEditingController nombre = TextEditingController();
  TextEditingController identidad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  final firebase = FirebaseFirestore.instance; //Instanciacion de firebase

  bool mostrar = true;

  Token tk = Token();

  insertarDatos() async {
    try {
      //String tok = await tk.generarToken();
      if (nombre.text.length != 0 &&
          identidad.text.length != 0 &&
          correo.text.length != 0 &&
          telefono.text.length != 0 &&
          contrasena.text.length != 0) {
        var bytes = utf8.encode(contrasena.text); // datos que se procesan
        var digest = sha256.convert(bytes);
        print("Digerir como bytes: ${digest.bytes}");
        print("Digerir como hex string: $digest");

        /*var bytes2 = utf8.encode('prueba1'); // data being hashed
        var digest2 = sha256.convert(bytes2);

        print("Digest as bytes: ${digest2.bytes}");
        print("Digest as hex string: $digest2");*/

        await firebase.collection('Usuarios').doc().set({
          "NombreUsuario": nombre.text,
          "IdentidadUsuario": identidad.text,
          "CorreoUsuario": correo.text,
          "TelefonoUsuario": telefono.text,
          "ContrasenaUsuario": digest.toString(),
          "Rol": "Invitado",
          "Estado": true,
          "Token": await tk.generarToken(),
        });
        print('Envio correcto');
        //ShowDialog
        mensaje(context, 'Mensaje', '¡Registro Exitoso!',
            (context) => Navigator.pop(context));
      } else {
        print('Todos los campos deben estar llenos');
        mensaje(context, 'Alerta', '¡Todos los campos deben estar llenos!',
            (context) => Navigator.pop(context));
      }
    } catch (e) {
      print('error en insert.... ' + e.toString());
    }
  }
  //aqui va el metodo mensaje

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
        backgroundColor: Color(0xff757575),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  //Margen a los lados
                  top: 10,
                  left: 10,
                  right: 10),
              child: Container(
                //Dimensiones internas contenedor
                width: 200,
                height: 200,
                child: Image.asset('img/registro.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 20, right: 10),
              child: TextField(
                controller: nombre,
                style: TextStyle(
                  color: Color(0xFF0097ff),
                ),
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Digite nombre de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: identidad,
                decoration: InputDecoration(
                  labelText: 'Documento',
                  hintText: 'Digite documento de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: correo,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  hintText: 'Digite correo de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: telefono,
                decoration: InputDecoration(
                  labelText: 'Telefono',
                  hintText: 'Digite telefono de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: contrasena,
                obscureText: mostrar,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Digite contraseña de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                          mostrar ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          mostrar = !mostrar;
                        });
                      }),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  //print(nombre.text);
                  //correo.text="botón presionado";
                  insertarDatos();
                  nombre.clear();
                  correo.clear();
                  identidad.clear();
                  telefono.clear();
                  contrasena.clear();
                },
                child: Text('Enviar'),
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
