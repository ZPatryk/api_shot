import 'package:api_shot/onerandomuser/random_user.service.dart';
import 'package:flutter/material.dart';
import 'package:api_shot/user_model.dart';
import 'package:api_shot/onerandomuser/user_ui.dart';

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({Key? key}) : super(key: key);

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  final RandomUserService _randomUserService =
      RandomUserService(); // Instancja serwisu
  UserModel? user; // Dane użytkownika

  // Funkcja wywołująca metodę serwisu
  Future<void> fetchRandomUser() async {
    try {
      final fetchedUser = await _randomUserService.fetchRandomUser();
      setState(() {
        user = fetchedUser; // Aktualizacja stanu po pobraniu danych
      });
    } catch (e) {
      // Obsługa błędów, np. wyświetlenie alertu
      print('Błąd: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserUI(
      user: user, // Przekazanie użytkownika do UI
      onFetchUser: fetchRandomUser, // Przekazanie funkcji do UI
    );
  }
}
