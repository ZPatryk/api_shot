class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String pictureUrl;

  // Konstruktor modelu
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.pictureUrl,
  });

  // Funkcja do mapowania danych JSON na obiekt UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      email: json['email'],
      pictureUrl: json['picture']['large'],
    );
  }
}
