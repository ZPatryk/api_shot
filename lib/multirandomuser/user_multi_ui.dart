import 'package:api_shot/UserDetailsScreen.dart';
import 'package:api_shot/multirandomuser/random_mutli_user.dart';
import 'package:api_shot/user_list.dart';
import 'package:flutter/material.dart';
import '../errorscreen/error_screen401.dart';
import '../errorscreen/error_screen404.dart';
import '../errorscreen/error_screen500.dart';
import '../errorscreen/error_screenUnknow.dart';
import '../sqlite/database_helper.dart';
import '../user_model.dart';

class RandomUserMultiScreen extends StatefulWidget {
  const RandomUserMultiScreen({super.key});

  @override
  State<RandomUserMultiScreen> createState() => _RandomUserMultiScreenState();
}

class _RandomUserMultiScreenState extends State<RandomUserMultiScreen> {
  List<UserModel>? users;
  List<UserModel>? displayedUsers;
  final userService = UserService();
  final TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();

  // inicjalizacja bazydanych
  final UserDatabase database = UserDatabase();

  @override
  void initState() {
    super.initState();
    loadUsers();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoading) {
        loadUsers();
      }
    });
  }

  Future<void> loadUsers() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedUsers =
          await userService.fetchRandomUsers(page: currentPage);
      setState(() {
        if (users == null) {
          users = fetchedUsers;
        } else {
          users!.addAll(fetchedUsers);
        }
        displayedUsers = List.from(users!);
        hasMore = fetchedUsers.isNotEmpty;
        if (hasMore) currentPage++;
      });
    } on NotFoundException {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error404Screen()),
      );
    } on UnauthorizedException {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error401Screen()),
      );
    } on ServerErrorException {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error500Screen()),
      );
    } on UnknownErrorException {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorUnknownScreen()),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Losowi użytkownicy'),
        actions: [
          // dodanie ikony w prawym rogu AppBar
          IconButton(
            icon: const Icon(Icons.navigate_next), // ikona strzałki
            onPressed: () {
              // nawigacja do kolejnego ekranu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Wyszukaj użytkownika',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => filterUsers(query),
            ),
          ),
          ElevatedButton(
              onPressed: sortUserAlphabetically,
              child: const Text('Posortuj użytkowników')),
          Expanded(
            child: displayedUsers == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: scrollController,
                    itemCount: displayedUsers!.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < displayedUsers!.length) {
                        final user = displayedUsers![index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.pictureUrl),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.email),
                          onTap: () {
                            Navigator.of(context).push(_createRoute(user));
                          },
                          trailing: GestureDetector(
                            onTap: () {
                              _onUserPressed(user);
                              _showDialog(context);
                            },
                            child: Icon(Icons.save),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(UserModel user) {
    // Tworzymy niestandardowy route z animacją.
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UserDetailScreen(
        firstName: user.firstName,
        lastName: user.lastName,
        gender: user.gender,
        city: user.city,
        country: user.country,
        postcode: user.postcode,
      ), // Docelowa strona.
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animacja przejścia: przesunięcie nowej strony.
        const begin = Offset(
            1.0, 0.0); // Początek animacji (poza ekranem z prawej strony).
        const end = Offset.zero; // Koniec animacji (na środku ekranu).
        const curve = Curves.easeInOut; // Typ krzywej animacji.

        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve)); // Łączymy tween z krzywą.
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation, // Przekazujemy animację przesunięcia.
          child: child, // Dziecko, czyli strona docelowa.
        );
      },
      transitionDuration: Duration(milliseconds: 1500),
    );
  }

  void _onUserPressed(UserModel user) {
    // Zapisanie użytkownika do bazy danych
    database.insertUser(user);
    print('Użytkownik zapisany do bazy danych: ${user.firstName}');
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informacja'),
          content: Text('Zapisano użytkownika'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }

  void sortUserAlphabetically() {
    setState(() {
      displayedUsers!.sort((a, b) => a.firstName.compareTo(b.firstName));
    });
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedUsers = List.from(users!);
      } else {
        displayedUsers = users!.where((user) {
          final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
          final email = user.email.toLowerCase();
          final input = query.toLowerCase();
          return fullName.contains(input) || email.contains(input);
        }).toList();
      }
    });
  }
}
