import 'package:flutter/material.dart';
import 'package:notes_app/models/Note.dart';
import 'package:notes_app/screens/add_edit.dart';
import 'package:notes_app/screens/view_note.dart';
import 'package:notes_app/services/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  bool _isSearching = false;
  final List<Color> _noteColors = [
    Colors.amber,
    Color(0xFF50C878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  //focus
  final FocusNode _focusNode = FocusNode();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_loadNotes();
    _loadStaticNotes();
    _databaseHelper.logAllNotes();
  }

  void _loadStaticNotes() {
    Note note1 = Note(
      title: 'Meeting Notes',
      content: 'Discuss project milestones.',
      color: 'blue',
      dateTime: '2024-12-07',
    );

    Note note2 = Note(
      title: 'Reminder',
      content: 'Call the doctor.',
      color: 'red',
      dateTime: '2024-12-08',
      isPinned: true,
    );
    Note note3 = Note(
      title: 'Shopping List',
      content: 'Buy milk, bread, eggs, and coffee.',
      color: 'green',
      dateTime: '2024-12-09',
    );
    _notes = [note1, note2, note3]
      ..sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _searchNotes(String value) async {
    final notes = await _databaseHelper.searchNotes(value);
    if (value.isEmpty)
      _loadNotes();
    else
      setState(() {
        _notes = notes;
      });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}:${dt.minute.toString().padLeft(0, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: !_isSearching
            ? Text(
                "My Notes",
              )
            : TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: "Search By Title or Content...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _searchNotes(value);
                },
              ),
        actions: [
          IconButton(
            iconSize: 32,
            onPressed: () {
              _toggleSearch();
              _loadNotes();
            },
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
          )
        ],
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            final color = Color(int.parse(note.color));

            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewNote(note: note),
                    ));
                _loadNotes();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      _formatDateTime(note.dateTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        note.isPinned = !note.isPinned;
                        _loadStaticNotes();
                        // await _databaseHelper.updateNote(note);
                        // _loadNotes();
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEdit(),
              ));
          _loadNotes();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF50C878),
        foregroundColor: Colors.white,
      ),
    );
  }
}
