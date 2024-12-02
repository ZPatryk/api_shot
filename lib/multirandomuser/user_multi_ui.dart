import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../user_model.dart';

class RandomUserMultiScreen extends StatefulWidget {
  const RandomUserMultiScreen({super.key});

  @override
  State<RandomUserMultiScreen> createState() => _RandomUserMultiScreenState();
}

class _RandomUserMultiScreenState extends State<RandomUserMultiScreen> {
  List<UserModel>? users; // Lista użytkowników

  // Funkcja do pobierania 3 użytkowników z API
  Future<void> fetchRandomUsers() async {
    final url = Uri.parse('https://randomuser.me/api/?results=3'); // URL API
    final response = await http.get(url); // Wysyła żądanie GET

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Parsowanie JSON-a
      setState(() {
        users = (data['results'] as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList(); // Mapowanie JSON na listę użytkowników
      });
    } else {
      // Obsługuje błąd
      throw Exception('Nie udało się pobrać danych');
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
                onPressed: fetchRandomUsers, // Pobieranie użytkowników
                child: const Text('Załaduj użytkowników'),
              ),
            )
          : ListView.builder(
              itemCount: users!.length, // Liczba użytkowników
              itemBuilder: (context, index) {
                final user = users![index]; // Pobranie użytkownika z listy
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.pictureUrl), // Zdjęcie
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email), // Email użytkownika
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomUsers,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
