import 'package:flutter/material.dart';
import '../database/note.dart';
import '../database/database.dart';

class EditNotePage extends StatefulWidget {
  final Note passedNote;
  const EditNotePage({super.key, required this.passedNote});
  @override
  EditNotePageState createState() => EditNotePageState(passedNote: passedNote);
}

class EditNotePageState extends State<EditNotePage> {
  final Note passedNote;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DatabaseManager db = DatabaseManager();
  EditNotePageState({required this.passedNote});


  @override
  void initState() {
    super.initState();
    titleController.text = passedNote.title;
    descriptionController.text = passedNote.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Note",
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
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateNote();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.yellowAccent.shade100,
                ),
              ),
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  void _updateNote() {
    final String title = titleController.text;
    final String description = descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      final String notedate = DateTime.now().toString();
      final Note updatedNote = Note(
        id: passedNote.id,
        title: title,
        description: description,
        notedate: notedate,
      );
      db.updateNote(updatedNote);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Can't save note with empty title or description"),
        ),
      );
    }
  }
}
