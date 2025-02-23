import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytestapp/api_service.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ApiService(),
    );
  }
}
