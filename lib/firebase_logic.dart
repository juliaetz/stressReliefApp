import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';

//Google Gemini Assisted
Future<void> createUserDocument(User? user) async {
    if (user == null) {
      return; // No user is signed in
    }

    final userDocRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if the user document already exists
    final docSnapshot = await userDocRef.get();
    if (docSnapshot.exists) {
      return; // User document already exists
    }

    //Create user document
    await userDocRef.set({});

    // Create user collections
    userDocRef.collection('Mood');
    userDocRef.collection('events');
    userDocRef.collection('Favorite_Ideas');
    userDocRef.collection('Persistent_Variables');

    userDocRef.collection('Persistent_Variables').doc('Integers').set({
      'maxStreak': 0,
    });

  }