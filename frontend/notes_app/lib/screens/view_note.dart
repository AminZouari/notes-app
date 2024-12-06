import 'package:flutter/material.dart';
import 'package:notes_app/services/database_helper.dart';

import '../models/Note.dart';

class ViewNote extends StatelessWidget {
  final Note note;
  const ViewNote({required this.note});
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if(dt.year == now.year && dt.month == now.month && dt.day == now.day)
    {
      return 'Today, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(0,'0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}:${dt.minute.toString().padLeft(0,'0')}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async {} ,
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
