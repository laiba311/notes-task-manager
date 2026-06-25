import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_database_app/home.dart';

import 'note_model.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //we  Initializing Hive
  await Hive.initFlutter();

  // Register Hive Adapter which created automatically
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<Note>('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
