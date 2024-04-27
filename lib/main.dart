import 'package:flutter/material.dart';
import 'package:tp_election/pages/showelect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Election App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowElectPage(candidates: _candidates),
    );
  }
}