import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stress_managment_app/auth_gate.dart';
import 'package:stress_managment_app/firebase_logic.dart' as fire_base_logic;

//Originally created with Google Gemini
class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the sign-in/sign-up screen after sign out.
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthGate()));
    } catch (e) {
      // Handle sign out errors.
      print('Error signing out: $e');
    }
  }

  Future<void> _deleteAccount() async {
    if (_currentUser != null) {
      // Show a confirmation dialog before deleting the account.
      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  // Cancel deletion.
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  // Confirm deletion.
                  child: const Text('Delete'),
                ),
              ],
            ),
      );

      if (confirmDelete == true) {
        // First, delete the user's data from Firestore.
        print(_currentUser!.uid);
       await fire_base_logic.deleteUserData(_currentUser!.uid);
        // Now, delete the user account.
        try {
          await _currentUser!.delete();
          // User account and data should be deleted.
          print("Account deletion successful");
          // Navigate to the sign-in/sign-up screen after deletion.
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthGate()));
        } catch (error) {
          print("Error deleting user: $error");
          // Handle the error appropriately, maybe show an error message to the user.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $error')),
          );
        }
      }
    } else {
      print("No current user to delete");
    }
  }

  Future<void> _changePassword() async {
    if (_currentUser != null && _currentUser!.email != null) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _currentUser!.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent. Check your email.')),
        );
      } on FirebaseAuthException catch (e) {
        // Handle password change errors.
        print('Error sending password reset email: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending password reset email: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/purple_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 100, color: Colors.deepPurpleAccent),
                if (_currentUser != null)
                  Text(
                    '${_currentUser!.email}',
                    style: const TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_right),
                  onPressed: _signOut,
                  label: const Text('Sign Out'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.key),
                  onPressed: _changePassword, //call the new function
                  label: const Text('Change Password'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.delete),
                  onPressed: _deleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .redAccent, // Make the button red to indicate it's a destructive action
                  ),
                  label: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}