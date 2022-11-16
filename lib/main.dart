import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/loading.dart';
import 'screens/todo_item_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ToDo List',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ToDo List',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: const Loading(),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo List',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const TodoItemPage(title: 'ToDo List'),
        );
      },
    );
  }
}
