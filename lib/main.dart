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

        // SET TEXT THEME!!
        /*
         some fonts that i think matches our vibe (delete this comment when we decide!)
         - balsamiqSans
         - splineSans
         - dotGothic16 (looks like a video game if we are interested in that!)
         - amiko
         - averageSans
         - akshar
         - contrailOne
         - aDLaMDisplay
         - rem
         - anekBangla
         - anybody
         - murecho
         - farro
         - playpenSans
         */
        textTheme: GoogleFonts.amikoTextTheme(),

        primarySwatch: Colors.blue,
      ),
      home: AuthGate(), // Set HomePage as the start page
    );
  }
}
