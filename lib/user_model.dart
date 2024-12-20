class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String pictureUrl;
  final int age;
  final String gender;
  final String city;
  final String country;
  final int? postcode;

  // Konstruktor modelu
  UserModel({
    required this.gender,
    required this.city,
    required this.country,
    required this.postcode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.pictureUrl,
    required this.age,
    required name,
  });

  // Funkcja do mapowania danych JSON na obiekt UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      email: json['email'],
      pictureUrl: json['picture']['large'],
      age: json['dob']['age'],
      gender: json['gender'],
      city: json['location']['city'],
      country: json['location']['country'],

      postcode: json['location']['postcode'] is int
          ? json['location']['postcode'] // jesli jest int, zostaw
          : int.tryParse(json['location']['postcode']?.toString() ??
              ''), //jesli String to proba sparsowania
      name: json['name']['first'] ?? 'Unknow',
    );
  }
}
