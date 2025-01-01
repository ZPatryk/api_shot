import 'package:flutter/material.dart';
import 'package:api_shot/user_model.dart';
import '../multirandomuser/user_multi_ui.dart';
import '../utils/styles.dart';

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
        backgroundColor: Colors.cyan,
        title: Text('Random User App'),
      ),
      body: Container(
        color: Colors.cyanAccent,
        child: Center(
          child: user == null
              ? Text('Kliknij przycisk, aby pobrać dane')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(user!.pictureUrl),
                    Text(
                      '${user!.firstName} ${user!.lastName}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('${user!.email}'),
                    Text('Wiek: ${user!.age}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent,
                        ),
                        onPressed: onFetchUser,
                        child: Text('Pobierz nowego użytkownika')),
                  ],
                ),
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.lightGreenAccent,
            onPressed: onFetchUser,
            child: Icon(Icons.refresh),
          ),
          SizedBox(
            width: 90,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomUserMultiScreen(),
                ),
              );
            },
            child: Text(
              'Przejdź do drugiego ekranu',
              style: AppStyles.buttonStyle,
            ),
          ),
        ],
      ),
    );
  }
}
