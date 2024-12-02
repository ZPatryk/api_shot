import 'package:api_shot/user_model.dart';
import 'package:api_shot/onerandomuser/user_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({super.key});

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  // Przechowuje dane użytkownika
  UserModel? user;

  // Funkcja do pobierania danych API
  Future<void> fetchRandomUser() async {
    final url = Uri.parse('https://randomuser.me/api/?results=1');
    final response = await http.get(url); // Wysyła żądanie GET.

    if (response.statusCode == 200) {
      // Jesli żądanie sie powiodlo
      final data = json.decode(response.body);
      setState(() {
        user = UserModel.fromJson(data['results'][0]);
      });
    } else {
      // Obsługa bledu gdy API zwrac inny kod statusu
      throw Exception('Nie udalo sie pobrac danych');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserUI(
      user: user,
      onFetchUser: fetchRandomUser,
    );
  }
}
