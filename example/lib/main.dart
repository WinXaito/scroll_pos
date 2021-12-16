import 'package:example/listview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExtendedListView demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        listTileTheme: ListTileThemeData(
          selectedTileColor: Colors.orangeAccent.withOpacity(0.3),
          selectedColor: Colors.black,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Extended ListView'),
        ),
        body: const ExampleAppContent(),
      ),
    );
  }
}
