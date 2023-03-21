import 'package:flutter/material.dart';

class SpendingsView extends StatelessWidget {
  const SpendingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('your spendings')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Spendings',
          ),
        ],
      ),
    );
  }
}
