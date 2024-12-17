import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String firstName;
  final String lastName;

  const UserDetailScreen(
      {super.key, required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$firstName $lastName'),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
