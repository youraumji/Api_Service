import 'package:flutter/material.dart';
import 'package:mytestapp/api_service.dart';

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
