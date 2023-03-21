
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project0/View/Bienvenida.dart';
import '../DTO/User.dart';

//librerias para usar crypto
import 'package:crypto/crypto.dart';
import 'dart:convert'; //para el método utf8.encode

class Login extends StatefulWidget {
  @override
  LoginApp createState() => LoginApp();
}

class LoginApp extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  User objUser = User();

  bool mostrar = true;
  validarDatos() async{
    try{
      var bytes = utf8.encode(pass.text); // datos que se procesan
      var digest = sha256.convert(bytes);
      print("Digerir como bytes: ${digest.bytes}");
      print("Digerir como hex string: $digest");

      CollectionReference ref = FirebaseFirestore.instance.collection('Usuarios');
      QuerySnapshot usuario = await ref.get();
      //Validacion si hay documentos
      if(usuario.docs.length != 0){
        for(var cursor in usuario.docs){
          if(cursor.get('CorreoUsuario') == email.text){
            print('Usuario encontrado');
            print('Nombre ---> ' + cursor.get('NombreUsuario'));
           if(cursor.get('ContrasenaUsuario') == digest.toString()){
              print('***** Acccediendo a su cuenta *****');
              print('Identificacion ----> '+cursor.get('IdentidadUsuario'));

              objUser.nombre = cursor.get('NombreUsuario');

              email.clear();
              pass.clear();
              Navigator.push(context, MaterialPageRoute(builder: (_)=> Bienvenida()));
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('Mensaje'),
                content: Text('¡Has accedido!'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Aceptar')),
                ],
              ));
            }else{
             print('Error en los datos');
             showDialog(context: context, builder: (context) => AlertDialog(
               title: Text('Alerta'),
               content: Text('¡Error en los datos!'),
               actions: <Widget>[
                 TextButton(
                     onPressed: () {
                       Navigator.pop(context);
                     },
                     child: Text('Aceptar')),
               ],
             ));
           }
          }
        }

      }else{
        print('No hay documentos en la coleccion');
      }

    }catch(e){
      print('error..... ' + e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login de usuarios"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        //Deslizar verticalmente
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
                child: Image.asset('img/login.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email User',
                  hintText: 'Digite email de usuario',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: pass,
                obscureText: mostrar,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Password',
                  hintText: 'Digite password de usuario',
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
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  print('Ingresando ...');
                  validarDatos();

                  //email.clear();
                  //pass.clear();
                },
                child: Text('Ingresar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
