import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LojaFacilApp());
}

class LojaFacilApp extends StatelessWidget {
  const LojaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja Fácil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}