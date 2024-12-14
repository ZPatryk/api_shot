// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user_model.dart';

// Definicja własnych wyjątków dla różnych statusów HTTP
class NotFoundException implements Exception {}

class UnauthorizedException implements Exception {}

class ServerErrorException implements Exception {}

class UnknownErrorException implements Exception {}

class UserService {
  Future<List<UserModel>> fetchRandomUsers({
    int page = 1,
    int results = 10,
  }) async {
    final url = Uri.parse(
        //'https://randomuser.me/api-fake/?results=$results&page=$page');
        'https://httpstat.us/505');
    final response = await http.get(url);

    // Obsługa statusów HTTP
    switch (response.statusCode) {
      case 200:
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
      case 404:
        throw NotFoundException(); // Błąd 404
      case 401:
        throw UnauthorizedException(); // Błąd 401
      case 500:
        throw ServerErrorException(); // Błąd 500
      default:
        throw UnknownErrorException(); // Nieznany błąd
    }
  }
}
