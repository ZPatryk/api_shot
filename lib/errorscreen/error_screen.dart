import 'package:flutter/material.dart';

// Ekran błędu z dynamicznym komunikatem
class ErrorScreen extends StatelessWidget {
  final String errorMessage; // Komunikat błędu

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Błąd'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Powrót do poprzedniego ekranu
                },
                child: const Text('Powrót'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
