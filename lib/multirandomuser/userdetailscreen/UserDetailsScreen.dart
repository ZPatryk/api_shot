import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  double _textPosition = -200; // początkowa pozycja poza ekranem

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _textPosition = 0; // przesuniecie tekstu na srodek
      });
    });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Płeć: ${widget.gender}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Kraj: ${widget.country}'),
              Text('Miasto: ${widget.city}'),
              Text('Kod pocztowy: ${widget.postcode}'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
