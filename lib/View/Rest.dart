import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Rest extends StatefulWidget {
  const Rest({super.key});

  @override
  RestApp createState() => RestApp();
}

class RestApp extends State<Rest> {
  consumirGet(String dato) async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$dato');
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      print(response.statusCode.toString());
      if (response.statusCode.toString() == '200') {
        title.text = '${data['title']}';
        code.text = response.statusCode.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  TextEditingController id = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController title = TextEditingController();
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
                controller: id,
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
                  consumirGet(id.text);
                  //Map datosResponse = await getRequest(id.text);
                  //code.text = datosResponse['responseBody'];
                  //title.text = datosResponse['statusCode'].toString();
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
                controller: code,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Code',
                  //hintText: 'Request',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: title,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Titulo',
                  //hintText: '',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    code.clear();
                    title.clear();
                    id.clear();
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

  /*Future<Map> getRequest(String dato) async {
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
  }*/
}
