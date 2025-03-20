import 'package:flutter/material.dart';
import 'home_page.dart';





// since we are using the MVP model, the main.dart file should ONLY contain the calls to the
//functionality in other files, i.e create files with the actual functionality and call them here
//like is done with HomePage()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Set HomePage as the start page
    );
  }
}
