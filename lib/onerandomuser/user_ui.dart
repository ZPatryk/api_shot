import 'package:api_shot/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../multirandomuser/user_multi_ui.dart';

class UserUI extends StatelessWidget {
  final UserModel? user; // Dane użytkownika
  final VoidCallback onFetchUser;

  const UserUI({
    Key? key,
    required this.user,
    required this.onFetchUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random User App'),
      ),
      body: Center(
        child: user == null
            ? Text('Klinij przycisk aby pobrac dane')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(user!.pictureUrl),
                  Text(
                    '${user!.firstName} ${user!.lastName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('${user!.email}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: onFetchUser,
                      child: Text('Pobierz nowego użytownika')),
                ],
              ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: onFetchUser,
            child: Icon(Icons.refresh),
          ),
          ElevatedButton(
            // Funkcja, która obsługuje naciśnięcie przycisku
            onPressed: () {
              // Przejście do kolejnego ekranu za pomocą Navigator.push
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomUserMultiScreen(),
                ),
              );
            },
            child: Text('Przejdź do drugiego ekranu'),
          ),
        ],
      ),
    );
  }
}
