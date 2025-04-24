import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_logic.dart' as fire_base_logic;
import 'package:stress_managment_app/view/homepage_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                fire_base_logic.createUserDocument(state.credential.user);
              }),
            ],
            providers: [
              EmailAuthProvider(),
            ],
          );
        }
        return HomePage();
      },
    );
  }
}