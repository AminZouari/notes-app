import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../models/Note.dart';
import '../services/database_helper.dart';

class AddEdit extends StatefulWidget {
  final Note? note;
  const AddEdit({this.note});

  @override
  State<AddEdit> createState() => _AddEditState();
}
class _AddEditState extends State<AddEdit> {
    final _formkey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    final DatabaseHelper _databaseHelper = DatabaseHelper();
    Color _selectedColor = Colors.amber;

    final List<Color> _colors = [
      Colors.amber,
      Color(0xFF50C878),
      Colors.redAccent,
      Colors.blueAccent,
      Colors. indigo,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ];

    @override
    void initState() {
      super.initState();
      if (widget.note != null) {
        _titleController.text = widget.note !.title;
        _contentController.text = widget.note !.content;
        _selectedColor = Color(int.parse(widget.note !.color));
      }
    }
    @override

    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.note == null ? 'Add_Note':'Edit Note'),
        ),
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please enter a title";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                          hintText: "Content",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      maxLines: 10,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please enter a content";
                        }
                        return null;
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _colors.map(
                          (color){
                          return GestureDetector(
                           onTap: () => setState(()=> _selectedColor = color),
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color ? Colors.white : Colors.transparent,
                                  width: 2
                                ),
                              ),
                            ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    ),
                  InkWell(
                    onTap: (){
                      //_saveNote();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Save Note",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      )
                    ),
                  )
                ],
               ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> _saveNote() async{
      if(_formkey.currentState!.validate()){
        final note = Note (
          id: widget.note?.id,
          title: _titleController.text,
          content: _contentController.text,
          color: _selectedColor.value.toString(),
          dateTime: DateTime.now().toString(),
        );

        if(widget.note == null){
          await _databaseHelper.insertNote(note);
        }
        else{
          await _databaseHelper.updateNote(note);

        }
      }
    }
}