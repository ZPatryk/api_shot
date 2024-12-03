// random_user_multi_screen.dart
import 'package:api_shot/multirandomuser/random_mutli_user.dart';
import 'package:flutter/material.dart';
import '../user_model.dart'; // Importujemy UserModel

class RandomUserMultiScreen extends StatefulWidget {
  const RandomUserMultiScreen({super.key});

  @override
  State<RandomUserMultiScreen> createState() => _RandomUserMultiScreenState();
}

class _RandomUserMultiScreenState extends State<RandomUserMultiScreen> {
  List<UserModel>? users; // Lista użytkowników
  final userService = UserService(); // Tworzymy instancję UserService

  // Funkcja do wywołania pobierania użytkowników
  Future<void> loadUsers() async {
    try {
      final fetchedUsers = await userService
          .fetchRandomUsers(); // Pobieranie użytkowników z serwisu
      setState(() {
        users = fetchedUsers; // Ustawiamy stan z pobranymi użytkownikami
      });
    } catch (e) {
      // Obsługuje błąd
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Losowi użytkownicy'),
      ),
      body: users == null
          ? Center(
              child: ElevatedButton(
                onPressed: loadUsers, // Ładowanie użytkowników po kliknięciu
                child: const Text('Załaduj użytkowników'),
              ),
            )
          : ListView.builder(
              itemCount: users!.length, // Liczba użytkowników
              itemBuilder: (context, index) {
                final user = users![index]; // Pobieranie użytkownika z listy
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(user.pictureUrl), // Zdjęcie użytkownika
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email), // Email użytkownika
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadUsers, // Przycisk do ponownego ładowania danych
        child: const Icon(Icons.refresh), // Ikona odświeżania
      ),
    );
  }
}
