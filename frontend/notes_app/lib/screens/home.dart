import 'package:flutter/material.dart';
import 'package:notes_app/models/Note.dart';
import 'package:notes_app/screens/add_edit.dart';
import 'package:notes_app/screens/view_note.dart';
import 'package:notes_app/services/database_helper.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  bool _isSearching = false;
  bool _isAscending = true;
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

  void shareNote(Note note) {
    String shareContent = 'Title: ${note.title}\n\n${note.content}';
    Share.share(shareContent, subject: 'Check out this note: ${note.title}');
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _databaseHelper.logAllNotes();
  }

  void _sortNotes() {
    setState(() {
      _notes.sort((a, b) {
        // Pinned notes come first
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;

        // Sort by date within pinned or unpinned notes
        final dateA = DateTime.parse(a.dateTime);
        final dateB = DateTime.parse(b.dateTime);
        return _isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
    });
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
      _sortNotes();
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
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
          ),
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
                _sortNotes(); // Re-trigger sorting
              });
            },
            tooltip: "Sort by Date",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                          ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 16,
                          child:IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),

                              onPressed: () {
                              shareNote(note);
                              },
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 16,
                            )),
                        ),
                      ],
                    ),

                      Expanded(child:
                      Text(
                        note.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDateTime(note.dateTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          Container(
                            width: 16,
                            child:IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                note.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () async {
                                note.isPinned = !note.isPinned;
                                await _databaseHelper.updateNote(note);
                                _loadNotes();
                              },
                            ),
                          ),
                            // IconButton(
                            //     onPressed: () {
                            //       shareNote(note);
                            //     },
                            //     icon: Icon(
                            //       Icons.share,
                            //       color: Colors.white,
                            //       size: 16,
                            //     )
                            // ),
                          ],
                        ))
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
