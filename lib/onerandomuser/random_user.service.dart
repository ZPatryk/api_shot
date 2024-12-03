import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_shot/user_model.dart';

class RandomUserService {
  // Metoda do pobierania użytkownika z API
  Future<UserModel> fetchRandomUser() async {
    final url = Uri.parse('https://randomuser.me/api/?results=1');
    final response = await http.get(url); // Wysyłanie żądania GET.

    if (response.statusCode == 200) {
      // Jeśli żądanie zakończyło się sukcesem
      final data = json.decode(response.body);
      return UserModel.fromJson(
          data['results'][0]); // Tworzenie modelu użytkownika.
    } else {
      // Obsługa błędu
      throw Exception('Nie udało się pobrać danych użytkownika');
    }
  }
}
