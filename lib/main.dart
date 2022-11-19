import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/loading.dart';
import 'screens/todo_item_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // switch (snapshot.connectionState) {

        //   case ConnectionState.none:
        //     // TODO: Handle this case.
        //     break;
        //   case ConnectionState.waiting:
        //     // TODO: Handle this case.
        //     break;
        //   case ConnectionState.active:
        //     // TODO: Handle this case.
        //     break;
        //   case ConnectionState.done:
        //     // TODO: Handle this case.
        //     break;
        // }
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes',
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
            title: 'Notes',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: const Loading(),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const TodoItemPage(title: 'Notes'),
        );
      },
    );
  }
}
