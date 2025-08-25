import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_gate.dart';
import 'package:stress_managment_app/view/homepage_view.dart';
import 'package:stress_managment_app/view/account_screens/sign_in_view.dart';
import 'package:stress_managment_app/view/account_screens/sign_up_view.dart';


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
      // Start the app in the login pages
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(),
        '/home': (context) => HomePage(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}
