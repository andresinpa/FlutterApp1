import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class Clima extends StatefulWidget {
  const Clima({super.key});

  @override
  ClimaApp createState() => ClimaApp();
}

class ClimaApp extends State<Clima> {
  TextEditingController miUbicacion =
      TextEditingController(); //Para campo de texto de ubicacion
  TextEditingController temperaturaC =
      TextEditingController(); //Para campo de texto de Temperatura °C
  TextEditingController temperaturaF =
      TextEditingController(); //Para campo de Texto de Temperatura en °F
  late Position position; //Para determinar la posicion con GPS
  String localizacion = ""; //Para el label de localizacion
  String tiempo = ""; //Para el label de fecha y hora
  String urlImagen = ""; //Para el campo de imagen
  String descripcionClima = ""; //Para descripcion de la imagen - pronostico
  String statusCode = ""; //Para el label del codigo de respuesta.
  consultarTemperatura(String latitud, String longitud) async {
    //Metodo para consumir API con parametros.
    try {
      //Se agrega a la URI la latitud y longitud.
      var url = Uri.parse(
          'https://weatherapi-com.p.rapidapi.com/current.json?q=$latitud%2C$longitud');

      final response = await get(url, headers: {
        //Peticion GET
        'content-type': 'application/octet-stream',
        'X-RapidAPI-Key': '288a83bec9mshe2b6204a23a36c2p1041adjsne2af9e7cff69',
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
      });
      Map data = jsonDecode(response.body); //Diccionario de respuesta.
      if (response.statusCode.toString() == '200') {
        //Acceso a los valores que se requieren del diccionario.
        temperaturaC.text = '${data['current']['temp_c']} °C';
        temperaturaF.text = '${data['current']['temp_f']} °F';
        setState(() {
          localizacion = data['location']['name'];
          tiempo = data['location']['localtime'];
          urlImagen = data['current']['condition']['icon'];
          descripcionClima = data['current']['condition']['text'];
          statusCode = 'Status Code: ${response.statusCode.toString()}';
        });
      }
    } catch (e) {
      //En caso de error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤 Clima 🌧'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    position = await determinePosition();
                    miUbicacion.text =
                        'Latitud: ${position.latitude.toStringAsFixed(3)} <--> Longitud: ${position.longitude.toStringAsFixed(3)}';
                    //Agregando parametros de latitud y longitud para agregar a la URI
                    consultarTemperatura(position.latitude.toString(),
                        position.longitude.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 38, 9, 90),
                  ),
                  child: const Text('Clima Actual'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                statusCode,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: miUbicacion,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabled: false,
                    labelText: 'Mi ubicación',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: temperaturaC,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabled: false,
                    labelText: 'Temperatura en Celsius',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: temperaturaF,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: false,
                      labelText: 'Temperatura en Fahrenheit'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      localizacion,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      tiempo,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: urlImagen != "",
                      child: Image.network('https:$urlImagen'),
                    ),
                    Text(
                      descripcionClima,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    miUbicacion.clear();
                    temperaturaC.clear();
                    temperaturaF.clear();
                    setState(() {
                      localizacion = "";
                      tiempo = "";
                      urlImagen = "";
                      descripcionClima = "";
                      statusCode = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 80, 43),
                  ),
                  child: const Text('Borrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
    } else {
      Geolocator.openLocationSettings();
      return Future.error('No disponible');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso denegado');
      }
    }
    //print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }
}
