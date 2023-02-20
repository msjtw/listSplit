import 'package:flutter/material.dart';

List<Note> notes = [];

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Your notes')),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return notes[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          newnote(context);
        }),
        tooltip: 'add Note',
        child: const Icon(Icons.add),
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

  Future<void> newnote(BuildContext context) async {
    var result = await Navigator.pushNamed(context, '/NoteAdd');
    if (!mounted) return;
    print(result);
    if (result != null) {
      setState(() {
        notes.add(Note(
          title: (result as Map)['head'],
          description: (result as Map)['description'],
        ));
      });
    }
  }
}

class Note extends StatefulWidget {
  Note({super.key, this.title = '', this.description = ''});

  String title;
  String description;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber[800],
                  borderRadius: BorderRadius.circular(8)),
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoteAdd extends StatefulWidget {
  const NoteAdd({super.key});

  @override
  State<NoteAdd> createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  Note note = Note(
    title: '',
    description: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'title',
                ),
                onChanged: (text) {
                  note.title = text;
                },
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'text...',
              ),
              onChanged: (text) {
                note.description = text;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          Navigator.pop(context, {'head': note.title, 'text': note.description});
        }),
        tooltip: 'save Note',
        child: const Icon(Icons.save),
      ),
    );
  }
}
