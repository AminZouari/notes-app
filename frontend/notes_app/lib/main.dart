import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future main() async {
  if (kIsWeb)
    databaseFactory = databaseFactoryFfiWeb;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nots App",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(color: Colors.black87)
      ),
      home: Home(),
    );
  }
}

