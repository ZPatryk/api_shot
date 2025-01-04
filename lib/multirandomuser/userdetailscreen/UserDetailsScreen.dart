import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class UserDetailScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final dynamic gender;
  final dynamic city;
  final dynamic country;
  final dynamic postcode;

  UserDetailScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.city,
    required this.country,
    required this.postcode,
  });

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  // Funkcja odpowiedzialna za animację
  Widget animatedText(String text, Duration duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // Tło elementu
          borderRadius: BorderRadius.circular(8), // Zaokrąglenie rogów
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Cień
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 200, end: 0), // Zakres przesunięcia
          duration: duration, // Różne czasy trwania
          curve: Curves.easeInOut, // Krzywa animacji
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value, 0), // Przesunięcie w poziomie
              child: Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(120, 6, 172, 86),
        title: Text('${widget.firstName} ${widget.lastName}'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 60, 193, 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              animatedText('Płeć: ${widget.gender}', Duration(seconds: 2)),
              AppStyles.mediumSpacing,
              animatedText('Kraj: ${widget.country}', Duration(seconds: 3)),
              AppStyles.mediumSpacing,
              animatedText('Miasto: ${widget.city}', Duration(seconds: 4)),
              AppStyles.mediumSpacing,
              animatedText(
                  'Kod pocztowy: ${widget.postcode}', Duration(seconds: 5)),
              AppStyles.mediumSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
