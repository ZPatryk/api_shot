import 'package:flutter/material.dart';
import 'onerandomuser/RandomUserScreen.dart';

void main() {
  runApp(RandomUserApp()); // Uruchamia aplikację.
}

class RandomUserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Wyłącza pasek debugowania.
      home: RandomUserScreen(), // Ustawia główny ekran aplikacji.
    );
  }
}
