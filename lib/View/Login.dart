import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/auth_strings.dart';
import '../DTO/User.dart';
//librerias para usar crypto
import 'package:crypto/crypto.dart';
import 'dart:convert'; //para el método utf8.encode

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'Administradores.dart';
import 'Invitados.dart';
import 'Registro.dart';

class Login extends StatefulWidget {
  @override
  LoginApp createState() => LoginApp();
}

class LoginApp extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  User objUser = User();
  final LocalAuthentication auth = LocalAuthentication();

  bool mostrar = true;
  validarDatos() async {
    try {
      var bytes = utf8.encode(pass.text); // datos que se procesan
      var digest = sha256.convert(bytes);
      print("Digerir como bytes: ${digest.bytes}");
      print("Digerir como hex string: $digest");

      CollectionReference ref =
          FirebaseFirestore.instance.collection('Usuarios');
      QuerySnapshot usuario = await ref.get();
      //Validacion si hay documentos
      if (usuario.docs.length != 0) {
        for (var cursor in usuario.docs) {
          if (cursor.get('CorreoUsuario') == email.text) {
            print('Usuario encontrado');
            print('Nombre ---> ' + cursor.get('NombreUsuario'));
            if (cursor.get('ContrasenaUsuario') == digest.toString()) {
              print('***** Acccediendo a su cuenta *****');
              print('Identificacion ----> ' + cursor.get('IdentidadUsuario'));

              objUser.nombre = cursor.get('NombreUsuario');
              objUser.id = cursor.get('IdentidadUsuario');
              objUser.rol = cursor.get('Rol');
              objUser.estado = cursor.get('Estado');

              email.clear();
              pass.clear();

              if (objUser.rol == 'Administrador') {
                mensaje(
                    context,
                    'Hola 🖐',
                    '¡Has accedido correctamente como ' + objUser.rol + " !",
                    (context) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Administradores(objUser.nombre))));
              } else {
                mensaje(
                    context,
                    'Hola 🖐',
                    '¡Has accedido correctamente como ' + objUser.rol + " !",
                    (context) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Invitados(objUser.nombre))));
              }
            } else {
              print('Error en los datos');
              mensaje(context, 'Alerta', '¡Los datos ingresados no coinciden!',
                  (context) => Navigator.pop(context));
            }
          }
        }
      } else {
        print('No hay documentos en la coleccion');
      }
    } catch (e) {
      print('error..... ' + e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login de usuarios"),
        backgroundColor: Color(0xff607D8B),
      ),
      body: SingleChildScrollView(
        //Deslizar verticalmente
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff009688),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(40, 40),
                  backgroundColor: Color(0xff009688),
                ),
                onPressed: () async {
                  if (await biometrico()) {
                    mensaje(context, 'Mensaje', '¡Atenticación aceptada!',
                        (context) => Navigator.pop(context));
                  }
                },
                child: Icon(Icons.sensor_occupied_rounded, size: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> biometrico() async {
    //print("biométrico");

    // bool flag = true;
    bool authenticated = false;

    const androidString = const AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Ajustes",
      signInTitle: "Ingrese",
      //fingerprintNotRecognized: 'Error de reconocimiento de huella digital',
      goToSettingsDescription: "Confirme su autenticación",
      //fingerprintSuccess: 'Reconocimiento de huella digital exitoso',
      biometricHint: "¡Por favor autenticarse!",
      //signInTitle: 'Verificación de huellas digitales',
      biometricNotRecognized: "No se reconoce",
      biometricRequiredTitle: "Required Title",
      biometricSuccess: "Autetenticación correcta",
      //fingerprintRequiredTitle: '¡Ingrese primero la huella digital!',
    );
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    // bool isBiometricSupported = await auth.();
    bool isBiometricSupported = await auth.isDeviceSupported();

    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(canCheckBiometrics); //Returns trueB
    // print("support -->" + isBiometricSupported.toString());
    print(availableBiometrics.toString()); //Returns [BiometricType.fingerprint]
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Autentíquese para acceder",
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
          androidAuthStrings: androidString);
      if (!authenticated) {
        authenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    /* if (!mounted) {
        return;
      }*/

    return authenticated;
  }
}
