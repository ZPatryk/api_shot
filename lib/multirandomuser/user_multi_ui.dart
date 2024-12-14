import 'package:api_shot/multirandomuser/random_mutli_user.dart';
import 'package:flutter/material.dart';
import '../errorscreen/error_screen.dart';
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
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadUsers(); // Automatyczne ładowanie użytkowników przy starcie
    scrollController.addListener(() {
      // Sprawdzenie czy użytkownik dotarł do końca listy
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoading) {
        loadUsers(); // Ładuj kolejną stronę
      }
    });
  }

  // Funkcja do pobrania użytkowników z API
  Future<void> loadUsers() async {
    if (isLoading) return; // Zapobiega wielokrotnemu ładowaniu
    setState(() {
      isLoading = true; // Ustawia flagę ładowania na true
    });

    try {
      final fetchedUsers = await userService.fetchRandomUsers(
          page: currentPage); // Pobieranie danych
      setState(() {
        if (users == null) {
          users = fetchedUsers; // Jeśli brak danych, inicjalizuj listę
        } else {
          users!.addAll(fetchedUsers); // Dodaj nowe dane do istniejących
        }
        displayedUsers = List.from(users!); // Dane do wyświetlenia

        hasMore = fetchedUsers.isNotEmpty;
        if (hasMore) {
          currentPage++; // Zwiększ numer strony
        }
      });
    } catch (e) {
      // Przekierowanie na ekran błędu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorScreen(errorMessage: e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Wyłącz flagę ładowania
      });
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
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Wyszukaj użytkownika',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => filterUsers(query), // Filtrowanie w locie
            ),
          ),
          Expanded(
            child: displayedUsers == null
                ? const Center(
                    child: CircularProgressIndicator(), // Ładowanie początkowe
                  )
                : ListView.builder(
                    controller: scrollController,
                    // Kontroler przewijania
                    itemCount: displayedUsers!.length + (hasMore ? 1 : 0),
                    // Dodaj 1 dla wskaźnika ładowania
                    itemBuilder: (context, index) {
                      if (index < displayedUsers!.length) {
                        final user = displayedUsers![index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.pictureUrl),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.email),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child:
                                CircularProgressIndicator(), // Wskaźnik ładowania
                          ),
                        );
                      }
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
