import 'package:flutter/material.dart';
import 'package:flutter_medellin/views/home_page.dart';

void main() => runApp(const FlutterMedApp());

class FlutterMedApp extends StatelessWidget {
  const FlutterMedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player Demo',
      theme: ThemeData(primaryColor: Colors.purple[900]),
      home: const HomePage(),
    );
  }
}
