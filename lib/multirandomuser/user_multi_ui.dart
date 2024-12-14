import 'package:api_shot/multirandomuser/random_mutli_user.dart';
import 'package:flutter/material.dart';
import '../errorscreen/error_screen401.dart';
import '../errorscreen/error_screen404.dart';
import '../errorscreen/error_screen500.dart';
import '../errorscreen/error_screenUnknow.dart';
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
      // Przekierowanie na ekran 404
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error404Screen()),
      );
    } on UnauthorizedException {
      // Przekierowanie na ekran 401
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error401Screen()),
      );
    } on ServerErrorException {
      // Przekierowanie na ekran 500
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Error500Screen()),
      );
    } on UnknownErrorException {
      // Przekierowanie na ekran nieznanego błędu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ErrorUnknownScreen(),
        ),
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
