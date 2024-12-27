class UserModel {
  final int?
      id; // Dodane pole id (może być null podczas tworzenia nowego użytkownika)
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
    this.id, // Pole opcjonalne
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
      id: null, // ID nie pochodzi z JSON, ponieważ jest generowane przez SQLite
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      email: json['email'],
      pictureUrl: json['picture']['large'],
      age: json['dob']['age'],
      gender: json['gender'],
      city: json['location']['city'],
      country: json['location']['country'],
      postcode: json['location']['postcode'] is int
          ? json['location']['postcode']
          : int.tryParse(json['location']['postcode']?.toString() ?? ''),
      name: json['name']['first'] ?? 'Unknow',
    );
  }

  // Metoda konwersji obiektu na Mapę, aby zapisać w SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Dodane pole id
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'pictureUrl': pictureUrl,
      'age': age,
      'gender': gender,
      'city': city,
      'country': country,
      'postcode': postcode,
    };
  }

  // Metoda do mapowania Map<String, dynamic> na obiekt UserModel (z SQLite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'], // Pobieranie ID z bazy danych
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      pictureUrl: map['pictureUrl'],
      age: map['age'],
      gender: map['gender'],
      city: map['city'],
      country: map['country'],
      postcode: map['postcode'],
      name: map['firstName'],
    );
  }
}
