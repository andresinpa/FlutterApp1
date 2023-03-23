import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/Login.dart';
import 'View/Registro.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  HomeStart createState() => HomeStart();
}

class HomeStart extends State<Home> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Principal",
      home: Scaffold(
        appBar: AppBar(
          title: Text("APP PRO v.1.0"),
          backgroundColor: Color(0xff689F38),
        ),
        body: Center(
          //Deslizar verticalmente
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
                  width: 200,
                  height: 200,
                  child: Image.asset('img/inicio.png'),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Login()));
                  },
                  child: Text('Login'),
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
                        context,
                        MaterialPageRoute(
                            builder: (_) => Registro(LoginApp().objUser)));
                  },
                  child: Text('Registro'),
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
