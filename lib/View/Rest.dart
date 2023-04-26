import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Rest extends StatefulWidget {
  const Rest({super.key});

  @override
  RestApp createState() => RestApp();
}

class RestApp extends State<Rest> {
  TextEditingController dato = TextEditingController();
  TextEditingController responsePeticion = TextEditingController();
  TextEditingController statusCode = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤖 HTTP Request'),
        backgroundColor: Color.fromARGB(255, 15, 114, 101),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: dato,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Dato',
                  //hintText: 'Request',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () async {
                  Map datosResponse = await getRequest(dato.text);
                  setState(() {
                    responsePeticion.text = datosResponse['responseBody'];
                    statusCode.text = datosResponse['statusCode'].toString();
                  });
                },
                child: Text('HTTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 85, 46),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: responsePeticion,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Response',
                  //hintText: 'Request',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: statusCode,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Code Response',
                  //hintText: '',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    responsePeticion.clear();
                    statusCode.clear();
                    dato.clear();
                  });
                },
                child: Text('Borrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 7, 38, 85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map> getRequest(String dato) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$dato');
    Response response = await get(url);
    final datosResponse = {
      'dato': dato,
      'responseBody': response.body,
      'statusCode': response.statusCode
    };
    return datosResponse;
    //print('Status code: ${response.statusCode}');
    //print('Headers: ${response.headers}');
    //print('Body: ${response.body}');
  }
}
