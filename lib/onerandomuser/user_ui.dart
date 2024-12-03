import 'package:flutter/material.dart';
import 'package:api_shot/user_model.dart';
import '../multirandomuser/user_multi_ui.dart';

class UserUI extends StatelessWidget {
  final UserModel? user; // Dane użytkownika
  final VoidCallback onFetchUser; // Callback do pobierania użytkownika

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
            ? Text('Kliknij przycisk, aby pobrać dane')
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
                      child: Text('Pobierz nowego użytkownika')),
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
            onPressed: () {
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
