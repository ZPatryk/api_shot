import 'package:api_shot/multirandomuser/random_mutli_user.dart';
import 'package:flutter/material.dart';
import '../user_model.dart'; // Import UserModel

class RandomUserMultiScreen extends StatefulWidget {
  const RandomUserMultiScreen({super.key});

  @override
  State<RandomUserMultiScreen> createState() => _RandomUserMultiScreenState();
}

class _RandomUserMultiScreenState extends State<RandomUserMultiScreen> {
  List<UserModel>? users; // Lista użytkowników
  List<UserModel>?
      displayedUsers; // Lista do wyświetlania (pełna lub filtrowana)
  final userService = UserService(); // Instancja serwisu
  final TextEditingController searchController =
      TextEditingController(); // Kontroler tekstu

  @override
  void initState() {
    super.initState();
    loadUsers(); // Automatyczne ładowanie użytkowników przy starcie
  }

  // Funkcja do pobrania użytkowników z API
  Future<void> loadUsers() async {
    try {
      final fetchedUsers =
          await userService.fetchRandomUsers(); // Pobieranie danych
      setState(() {
        users = fetchedUsers; // Ustawienie listy użytkowników
        displayedUsers =
            List.from(users!); // Początkowo wyświetlana jest pełna lista
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e')),
      );
    }
  }

  void sortUsersAlphabetically() {
    setState(() {
      displayedUsers!.sort((a, b) => a.firstName.compareTo(b.firstName));
    });
  }

  // Funkcja do filtrowania danych
  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedUsers =
            List.from(users!); // Jeśli pole jest puste, pokaż całą listę
      } else {
        displayedUsers = users!.where((user) {
          final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
          final email = user.email.toLowerCase();
          final input = query.toLowerCase();
          return fullName.contains(input) ||
              email.contains(input); // Filtrowanie po nazwisku i emailu
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Losowi użytkownicy'),
      ),
      body: Column(
        children: [
          // Pole wyszukiwania
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController, // Kontroler tekstu
              decoration: const InputDecoration(
                labelText: 'Wyszukaj użytkownika',
                border: OutlineInputBorder(),
              ),
              onChanged: filterUsers, // Filtrowanie w locie
            ),
          ),
          ElevatedButton(
              onPressed: sortUsersAlphabetically,
              child: Text('Posortuj użytkowników')),
          // Lista użytkowników lub komunikaty
          Expanded(
            child: displayedUsers == null
                ? const Center(
                    child:
                        CircularProgressIndicator(), // Jeśli dane są ładowane
                  )
                : displayedUsers!.isEmpty
                    ? const Center(
                        child: Text(
                            'Brak wyników do wyświetlenia.'), // Jeśli brak wyników
                      )
                    : ListView.builder(
                        itemCount: displayedUsers!.length,
                        // Liczba elementów do wyświetlenia
                        itemBuilder: (context, index) {
                          final user = displayedUsers![index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  user.pictureUrl), // Zdjęcie użytkownika
                            ),
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle: Text(user.email),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadUsers, // Przycisk do odświeżania danych
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
