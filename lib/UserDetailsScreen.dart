import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String firstName;
  final String lastName;

  final dynamic gender;

  final dynamic city;

  final dynamic country;

  final dynamic postcode;

  const UserDetailScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.city,
    required this.country,
    required this.postcode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(12, 12, 12, 12),
        title: Text('$firstName $lastName'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 171, 154, 189), // Brakujący przecinek
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Płeć: $gender',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Kraj: $country'),
              Text('Miasto: $city'),
              Text('Kod pocztowy: $postcode'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
