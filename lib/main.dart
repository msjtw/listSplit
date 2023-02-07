import 'package:flutter/material.dart';
import 'noteview.dart';
import 'spendingview.dart';

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
        '/NoteView': (context) => const NoteView(),
        '/NoteAdd': (context) => const NoteAdd(),
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
      child: NoteView(),
    );
  }
}
