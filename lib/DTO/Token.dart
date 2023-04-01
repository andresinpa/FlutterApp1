import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Token {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String isToken = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> generarToken() async {
    await Firebase.initializeApp();
    isToken = (await FirebaseMessaging.instance.getToken())!;
    print('dato ---> ' + isToken);
    return await isToken;
  }
}
