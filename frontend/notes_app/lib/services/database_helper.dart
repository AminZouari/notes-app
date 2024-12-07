import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Note.dart';

class DatabaseHelper{
    static final DatabaseHelper _instance = DatabaseHelper._internal();
    static Database? _database;

    factory DatabaseHelper()=> _instance;
    DatabaseHelper._internal();

    Future<Database> get database async{
      if(_database != null) return _database!;
      _database = await _initDatabase();
      return _database!;
    }

    Future<Database> _initDatabase() async{
      String path = join(await getDatabasesPath(), 'notes_db.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }

    Future<void> _onCreate(Database db, int version) async {
      await db.execute('''
        CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color TEXT,
        dateTime TEXT
        )
        ''');
    }

    Future<int> insertNote(Note note) async {
      final db = await database;
      return await db.insert('notes', note.toMap());
    }

    Future<List<Note>> getNotes() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('notes');
        return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
    }

    Future<List<Note>> searchNotes(String query) async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT * FROM notes
        WHERE title LIKE ? OR content LIKE ?
        ''', ['%$query%', '%$query%']);
      return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
    }

    Future<int> updateNote(Note note) async {
      final db = await database;
      return await db.update(
          'notes',
          note.toMap(),
          where: 'id = ?',
          whereArgs: [note.id],
      );
    }
          Future<int> deleteNote(int id) async {
            final db = await database;
            return await db.delete(
              'notes',
              where: 'id = ?',
              whereArgs: [id],
            );
          }


    // print all notes to console for verif usage
    Future<void> logAllNotes() async {
      List<Note> notes = await getNotes(); // Fetch all notes
      for (var note in notes) {
        print('Note ID: ${note.id}, Title: ${note.title}, Color: ${note.color}, DateTime: ${note.dateTime}');
      }
    }
}