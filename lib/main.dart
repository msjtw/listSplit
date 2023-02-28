import 'package:flutter/material.dart';
import 'spendingview.dart';
import 'shoppinglist.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notes app',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/ShoppingListView': (context) => ShoppingListView(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ShoppingListView(),
    );
  }
}
