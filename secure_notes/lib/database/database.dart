import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  late Database _database;
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  Future<Database> get database async {
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notes_database.db');
    // Check if the database file already exists
    bool exists = await databaseExists(path);
    if (!exists) {
      // If the database file doesn't exist, copy it from the assets directory
      ByteData data = await rootBundle.load('assets/notes_database.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, version: 1);
  }

Future<void> _createDatabase(Database db, int version) async {
  await db.execute(
    'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT, notedate TEXT)',
  );
}


  Future<List<Note>> getAllNotes() async {
    final db = await database;
    List<Map<String, dynamic>> entries = await db.query('notes');
    return List.generate(entries.length, (i) {
      return Note(
        id: entries[i]['id'],
        title: entries[i]['title'],
        description: entries[i]['description'],
        notedate: entries[i]['notedate'],
      );
    });
  }

  Future<void> addNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap());
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id]
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<void> deleteAllNotes() async {
    final db = await database;
    await db.delete('notes');
  }
}
