import 'package:api_shot/sqlite/database_helper.dart';
import 'package:flutter/material.dart';
import '../user_model.dart'; // Model użytkownika

class UserListPage extends StatelessWidget {
  // Instancja bazy danych
  final UserDatabase userDatabase = UserDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista użytkowników'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: userDatabase.getUsers(), // Pobranie danych za pomocą getUsers
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jeśli dane są w trakcie ładowania
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Jeśli wystąpił błąd
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Jeśli brak danych
            return Center(child: Text('Brak użytkowników do wyświetlenia'));
          } else {
            // Jeśli dane zostały pobrane
            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.pictureUrl != null
                        ? NetworkImage(user.pictureUrl!) // URL zdjęcia
                        : null,
                    child: user.pictureUrl == null
                        ? Icon(Icons.person) // Ikonka, jeśli brak zdjęcia
                        : null,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  // Imię i nazwisko
                  subtitle: Text(user.email),
                  // E-mail
                  trailing: Text(user.age != null ? '${user.age} lat' : ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}
