import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Inventario extends StatefulWidget {
  final String nombre;
  const Inventario(this.nombre, {super.key});
  @override
  InventarioApp createState() => InventarioApp();
}

class Producto {
  final String nombreProducto;
  final String precio;
  final String marca;
  final String descripcion;

  Producto(this.nombreProducto, this.precio, this.marca, this.descripcion);

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      json['nombreProducto'],
      json['precio'],
      json['marca'],
      json['descripcion'],
    );
  }
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
                child: const Text('Aceptar')),
          ],
        );
      },
    );

class InventarioApp extends State<Inventario> {
  TextEditingController idProducto = TextEditingController();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController precioProducto = TextEditingController();
  TextEditingController marcaProducto = TextEditingController();
  TextEditingController descripcionProducto = TextEditingController();
  String statusCode = "";
  final firebase = FirebaseFirestore.instance; //Instanciacion de firebase
  String selectedOption = "Seleccionar";
  bool fieldEnabledId = false;
  bool fieldEnabledOtros = false;

  //METODO GET
  consultarInventario(id) async {
    try {
      var url =
          Uri.parse('http://jesusinfante.pythonanywhere.com/productos/$id');
      Response response = await get(url);
      //print(url);
      //print(response);
      Map data = jsonDecode(response.body); //Diccionario de respuesta.
      //print(data);
      if (response.statusCode.toString() == '200') {
        //Acceso a los valores que se requieren del diccionario.
        if ('${data['nombreProducto']}' != 'null' &&
            '${data['precio']}' != 'null' &&
            '${data['marca']}' != 'null' &&
            '${data['descripcion']}' != 'null') {
          nombreProducto.text = '${data['nombreProducto']}';
          precioProducto.text = '${data['precio']}';
          marcaProducto.text = '${data['marca']}';
          descripcionProducto.text = '${data['descripcion']}';
          // ignore: use_build_context_synchronously
          mensaje(context, 'Mensaje', '¡Producto encontrado!',
              (context) => Navigator.pop(context));
        } else {
          // ignore: use_build_context_synchronously
          mensaje(
              context,
              'Mensaje',
              '¡El producto no existe, puede eliminarlo en Firestore!',
              (context) => Navigator.pop(context));
          nombreProducto.clear();
          precioProducto.clear();
          marcaProducto.clear();
          descripcionProducto.clear();
        }
      }
      setState(() {
        statusCode = 'Status Code: ${response.statusCode.toString()}';
      });
    } catch (e) {
      //En caso de error
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //METODO POST
  agregarProducto() async {
    try {
      var url = Uri.parse('http://jesusinfante.pythonanywhere.com/productos');

      if (nombreProducto.text.isNotEmpty &&
          precioProducto.text.isNotEmpty &&
          descripcionProducto.text.isNotEmpty &&
          marcaProducto.text.isNotEmpty) {
        final producto = Producto(nombreProducto.text, precioProducto.text,
            marcaProducto.text, descripcionProducto.text);

        Response response = await post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'nombreProducto': producto.nombreProducto,
            'precio': producto.precio,
            'marca': producto.marca,
            'descripcion': producto.descripcion,
          }),
        );

        if (response.statusCode == 200) {
          //final newProducto = Producto.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          mensaje(context, 'Mensaje', '¡Producto creado!',
              (context) => Navigator.pop(context));
          //print('Nuevo Producto: $newProducto');
        } else {
          // ignore: use_build_context_synchronously
          mensaje(
              context,
              'Mensaje',
              'Fallo al crear el producto. Status code: ${response.statusCode}',
              (context) => Navigator.pop(context));
          //print('Fallo al crear el producto. Status code: ${response.statusCode}');
        }

        setState(() {
          statusCode = 'Status Code: ${response.statusCode}';
        });
      } else {
        mensaje(context, 'Mensaje', '¡Llene todos los campos solicitados!',
            (context) => Navigator.pop(context));
      }
    } catch (e) {
      //En caso de error
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //METODO PUT
  actualizarProducto(id) async {
    try {
      var url =
          Uri.parse('http://jesusinfante.pythonanywhere.com/productos/$id');

      if (nombreProducto.text.isNotEmpty &&
          precioProducto.text.isNotEmpty &&
          descripcionProducto.text.isNotEmpty &&
          marcaProducto.text.isNotEmpty) {
        final producto = Producto(
          nombreProducto.text,
          precioProducto.text,
          marcaProducto.text,
          descripcionProducto.text,
        );

        Response response = await put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'nombreProducto': producto.nombreProducto,
            'precio': producto.precio,
            'marca': producto.marca,
            'descripcion': producto.descripcion,
          }),
        );

        if (response.statusCode == 200) {
          // El producto se actualizó exitosamente
          // ignore: use_build_context_synchronously
          mensaje(context, 'Mensaje', '¡Producto actualizado!',
              (context) => Navigator.pop(context));
        } else {
          // Error al actualizar el producto
          // ignore: use_build_context_synchronously
          mensaje(
              context,
              'Mensaje',
              'Fallo al actualizar el producto. Status code: ${response.statusCode}',
              (context) => Navigator.pop(context));
        }

        setState(() {
          statusCode = 'Status Code: ${response.statusCode}';
        });
      } else {
        mensaje(
            context,
            'Mensaje',
            '¡Primero haga un get y despues llene todos los campos solicitados!',
            (context) => Navigator.pop(context));
      }
    } catch (e) {
      // En caso de error
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //METODO DELETE
  Future<void> eliminarProducto(String id) async {
    try {
      var url =
          Uri.parse('http://jesusinfante.pythonanywhere.com/productos/$id');
      if (nombreProducto.text.isNotEmpty &&
          precioProducto.text.isNotEmpty &&
          descripcionProducto.text.isNotEmpty &&
          marcaProducto.text.isNotEmpty) {
        var response = await delete(url);
        if (response.statusCode == 200) {
          // El producto se eliminó correctamente
          // ignore: use_build_context_synchronously
          mensaje(context, 'Mensaje', '¡Producto eliminado!',
              (context) => Navigator.pop(context));
        } else {
          // Ocurrió un error al eliminar el producto
          // ignore: use_build_context_synchronously
          mensaje(
              context,
              'Mensaje',
              'Fallo al eliminar el producto. Status code: ${response.statusCode}',
              (context) => Navigator.pop(context));
        }
        setState(() {
          statusCode = 'Status Code: ${response.statusCode}';
        });
      } else {
        mensaje(
            context,
            'Mensaje',
            '¡Primero haga un get para identificar el producto a eliminar!',
            (context) => Navigator.pop(context));
      }
    } catch (e) {
      // Ocurrió un error durante la solicitud DELETE
      // ignore: avoid_print
      print('Error al realizar la solicitud DELETE: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🛒 Inventario Productos 🛒 $statusCode'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: DropdownButton<String>(
                  value: selectedOption,
                  hint: const Text('Selecciona una opción'),
                  style:
                      const TextStyle(color: Color.fromRGBO(9, 148, 50, 0.925)),
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 3, 90, 7),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                      statusCode = "";
                    });
                    if (selectedOption == 'GET') {
                      fieldEnabledId = true;
                      fieldEnabledOtros = false;
                    } else if (selectedOption == 'POST') {
                      idProducto.clear();
                      nombreProducto.clear();
                      descripcionProducto.clear();
                      precioProducto.clear();
                      marcaProducto.clear();
                      fieldEnabledId = false;
                      fieldEnabledOtros = true;
                    } else if (selectedOption == 'PUT') {
                      fieldEnabledId = false;
                      fieldEnabledOtros = true;
                    } else {
                      fieldEnabledId = false;
                      fieldEnabledOtros = false;
                    }
                  },
                  items: <String>['Seleccionar', 'GET', 'DELETE', 'PUT', 'POST']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedOption == 'GET') {
                            var id = idProducto.text;
                            consultarInventario(id);
                          } else if (selectedOption == 'POST') {
                            agregarProducto();
                            idProducto.clear();
                            nombreProducto.clear();
                            descripcionProducto.clear();
                            precioProducto.clear();
                            marcaProducto.clear();
                          } else if (selectedOption == 'PUT') {
                            var id = idProducto.text;
                            actualizarProducto(id);
                            idProducto.clear();
                            nombreProducto.clear();
                            descripcionProducto.clear();
                            precioProducto.clear();
                            marcaProducto.clear();
                          } else if (selectedOption == 'DELETE') {
                            var id = idProducto.text;
                            eliminarProducto(id);
                            idProducto.clear();
                            nombreProducto.clear();
                            descripcionProducto.clear();
                            precioProducto.clear();
                            marcaProducto.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 38, 9, 90),
                        ),
                        child: Text(selectedOption),
                      ),
                    ),
                    if (selectedOption == 'GET')
                      EnvioFirestore(
                          idProducto: idProducto,
                          nombreProducto: nombreProducto,
                          precioProducto: precioProducto,
                          descripcionProducto: descripcionProducto,
                          marcaProducto: marcaProducto,
                          firebase: firebase,
                          widget: widget),
                  ],
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
                  controller: idProducto,
                  enabled: fieldEnabledId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'ID Producto',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: nombreProducto,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabled: fieldEnabledOtros,
                    labelText: 'Nombre del producto',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: precioProducto,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: fieldEnabledOtros,
                      labelText: 'Precio del producto'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: marcaProducto,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: fieldEnabledOtros,
                      labelText: 'Marca del producto'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: descripcionProducto,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: fieldEnabledOtros,
                      labelText: 'Descripcion del producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EnvioFirestore extends StatefulWidget {
  const EnvioFirestore({
    super.key,
    required this.idProducto,
    required this.nombreProducto,
    required this.precioProducto,
    required this.descripcionProducto,
    required this.marcaProducto,
    required this.firebase,
    required this.widget,
  });

  final TextEditingController idProducto;
  final TextEditingController nombreProducto;
  final TextEditingController precioProducto;
  final TextEditingController descripcionProducto;
  final TextEditingController marcaProducto;
  final FirebaseFirestore firebase;
  final Inventario widget;

  @override
  State<EnvioFirestore> createState() => _EnvioFirestoreState();
}

class _EnvioFirestoreState extends State<EnvioFirestore> {
  String accionFirestore = "";

  @override
  Widget build(BuildContext context) {
    if (widget.idProducto.text.isNotEmpty &&
        widget.nombreProducto.text.isEmpty) {
      setState(() {
        accionFirestore = 'Eliminar de Firestore';
      });
    } else if (widget.idProducto.text.isNotEmpty &&
        widget.nombreProducto.text.isNotEmpty &&
        widget.precioProducto.text.isNotEmpty &&
        widget.descripcionProducto.text.isNotEmpty &&
        widget.marcaProducto.text.isNotEmpty) {
      setState(() {
        accionFirestore = 'Enviar a Firestore';
      });
    } else {
      accionFirestore = "";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final nombreUsuario = await getNombreUsuario();
            if (widget.idProducto.text.isNotEmpty &&
                nombreUsuario == widget.widget.nombre) {
              await widget.firebase
                  .collection('Productos')
                  .doc('${widget.idProducto.text}${widget.widget.nombre}')
                  .delete();

              if (widget.idProducto.text.isNotEmpty &&
                  widget.nombreProducto.text.isNotEmpty &&
                  widget.precioProducto.text.isNotEmpty &&
                  widget.descripcionProducto.text.isNotEmpty &&
                  widget.marcaProducto.text.isNotEmpty) {
                // ignore: use_build_context_synchronously
                await guardadoFirestore(context);
              } else {
                // ignore: use_build_context_synchronously
                mensaje(context, 'Alerta', '¡Producto eliminado de Firestore!',
                    (context) => Navigator.pop(context));
              }
            } else if (widget.idProducto.text.isNotEmpty &&
                widget.nombreProducto.text.isNotEmpty &&
                widget.precioProducto.text.isNotEmpty &&
                widget.descripcionProducto.text.isNotEmpty &&
                widget.marcaProducto.text.isNotEmpty) {
              // ignore: use_build_context_synchronously
              await guardadoFirestore(context);
            } else {
              // ignore: use_build_context_synchronously
              mensaje(
                  context,
                  'Alerta',
                  '¡Este producto no existe para este usuario!',
                  (context) => Navigator.pop(context));
            }
          } catch (e) {
            // ignore: avoid_print
            print('error en insert.... $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 9, 90, 50),
        ),
        child: Text(accionFirestore),
      ),
    );
  }

  Future<void> guardadoFirestore(BuildContext context) async {
    await widget.firebase
        .collection('Productos')
        .doc('${widget.idProducto.text}${widget.widget.nombre}')
        .set({
      "NombreUsuario": widget.widget.nombre,
      "IdProducto": widget.idProducto.text,
      "NombreProducto": widget.nombreProducto.text,
      "Precio": widget.precioProducto.text,
      "Marca": widget.marcaProducto.text,
      "Descripcion": widget.descripcionProducto.text,
    });
    // ignore: use_build_context_synchronously
    mensaje(context, 'Mensaje', '¡Producto en FireStore!',
        (context) => Navigator.pop(context));

    widget.idProducto.clear();
    widget.nombreProducto.clear();
    widget.precioProducto.clear();
    widget.marcaProducto.clear();
    widget.descripcionProducto.clear();
  }

  Future<String?> getNombreUsuario() async {
    var nombreUsuario = "";
    final snapshot = await widget.firebase
        .collection('Productos')
        .doc('${widget.idProducto.text}${widget.widget.nombre}')
        .get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final nombreUsuario = data['NombreUsuario'] as String?;
      return nombreUsuario;
    } else {
      return nombreUsuario;
    }
  }
}
