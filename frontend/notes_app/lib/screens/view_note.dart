import 'package:flutter/material.dart';
import 'package:notes_app/screens/add_edit.dart';
import 'package:notes_app/services/database_helper.dart';

import '../models/Note.dart';

class ViewNote extends StatelessWidget {
  final Note note;

  ViewNote({required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEdit(
                      note: note,
                    ),
                  ));
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () => _showDeleteDialog(context),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              )),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Delete Note",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Are you sure you want to delete this note?",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
              ],
            ));
    if(confirm == true){
      await _databaseHelper.deleteNote(note.id!);
      Navigator.pop(context);
    }
  }
}
