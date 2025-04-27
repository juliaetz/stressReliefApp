import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_gate.dart';

// since we are using the MVP model, the main.dart file should ONLY contain the calls to the
//functionality in other files, i.e create files with the actual functionality and call them here
//like is done with HomePage()

/*void main() {
  runApp(const MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Planner',
      theme: ThemeData(

        textTheme: GoogleFonts.amikoTextTheme(),

        primarySwatch: Colors.blue,
      ),
      home: AuthGate(), // Set LOGIN PAGE as the start page
    );
  }
}
