// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user_model.dart';

// Serwis odpowiedzialny za pobieranie użytkowników z API
class UserService {
  // Funkcja do pobierania użytkowników z API z obsługą paginacji
  Future<List<UserModel>> fetchRandomUsers({
    int page = 1, // domyślna pierwsza strona
    int results = 10, // Liczba uzytkownikow na stronie
  }) async {
    final url = Uri.parse('https://randomuser.me/api/?results=20');
    final response = await http.get(url); // Wysyłanie zapytania HTTP

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Parsowanie odpowiedzi JSON
      return (data['results'] as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList(); // Zwracamy listę obiektów UserModel
    } else {
      throw Exception('Nie udało się pobrać danych');
    }
  }
}
