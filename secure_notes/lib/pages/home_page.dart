import 'package:flutter/material.dart';
import 'package:secure_notes/database/database.dart';
import 'package:secure_notes/database/note.dart';
import 'add_note_page.dart';
import 'edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DatabaseManager db = DatabaseManager();

  void _reorderNotes(List<Note> notes, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Note item = notes.removeAt(oldIndex);
    notes.insert(newIndex, item);
    for (int i = 0; i < notes.length; i++) {
      notes[i].id = i + 1;
      db.updateNote(notes[i]);
    }
  }

  void _addNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage()),
    );
    // Refresh the list
    setState(() {});
  }

  void _deleteNote(int noteId) {
    db.deleteNote(noteId);
    // Refresh the list
    setState(() {});
  }

  void _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNotePage(passedNote: note)),
    );
    setState(() {});
  }

  void _deleteAllNotes() {
    db.deleteAllNotes();
    // Refresh the list
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Secure Notes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        backgroundColor: Colors.blueAccent.shade700,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              _addNote();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              _deleteAllNotes();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: db.getAllNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              _reorderNotes(snapshot.data!, oldIndex, newIndex);
            },
            children: snapshot.data!.map((note) {
              return Card(
                key: ValueKey(note.id),
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                color: Colors.yellowAccent.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                  subtitle: Text(
                    note.description,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey.shade700),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editNote(note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteNote(note.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
