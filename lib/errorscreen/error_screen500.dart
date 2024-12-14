import 'package:flutter/material.dart';

class Error500Screen extends StatelessWidget {
  const Error500Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Błąd 500 - Nie znaleziono'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Nie znaleziono zasobu!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Wróć'),
            ),
          ],
        ),
      ),
    );
  }
}
