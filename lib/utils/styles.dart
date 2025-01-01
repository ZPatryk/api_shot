import 'package:flutter/material.dart';

class AppStyles {
  // Style tekstu
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Roboto', // Zmienna czcionka
    fontSize: 24, // Duży rozmiar tekstu
    fontWeight: FontWeight.bold, // Pogrubienie
    color: Colors.black, // Czarny kolor tekstu
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w500, // Lekko pogrubiony tekst
    color: Colors.grey, // Szary kolor
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87, // Biały kolor tekstu
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87, // Ciemnoszary kolor
  );

  // Odstępy (SizeBox)
  static const SizedBox smallSpacing = SizedBox(height: 8);
  static const SizedBox mediumSpacing = SizedBox(height: 16);
  static const SizedBox largeSpacing = SizedBox(height: 32);
}
