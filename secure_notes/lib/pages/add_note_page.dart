import 'package:flutter/material.dart';
import '../database/note.dart';
import '../database/database.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseManager db = DatabaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
           "Add Note",
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        backgroundColor: Colors.blueAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveNote();
              },
              child: Text("Save"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.yellowAccent.shade100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final String notedate = DateTime.now().toString();
      final Note newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
        notedate: notedate,
      );

      db.addNote(newNote);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title and description cannot be empty."),
        ),
      );
    }
  }
}
