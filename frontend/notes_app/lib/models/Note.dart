// lib/models/note.dart

class Note {
    final int? id;
    final String title;
    final String content;
    final String color;
    final String dateTime;

    // Constructor
    Note({
        this.id,
        required this.title,
        required this.content,
        required this.color,
        required this.dateTime,
    });

    // Method to convert a Note object to a Map
    Map<String, dynamic> toJson() {
        return {
                'id': id,
                'title': title,
                'content': content,
                'color': color,
                'dateTime': dateTime,
    };
    }

    // Method to create a Note object from a Map
    factory Note.fromJson(Map<String, dynamic> json) {
        return Note(
          id: json['id'] as int?,
          title: json['title'] as String,
          content: json['content'] as String,
          color: json['color'] as String,
          dateTime: json['dateTime'] as String,
    );
    }

    // Method to convert a Note object to a Map
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'title': title,
        'content': content,
        'color': color,
        'dateTime': dateTime,
      };
    }
    // Method to create a Note object from a Map
    factory Note.fromMap(Map<String, dynamic> map) {
      return Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        color: map['color'] as String,
        dateTime: map['dateTime'] as String,
      );
    }
}