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
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _deletePasswordController = TextEditingController();

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
        builder: (context) => AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.'),
              TextField(
                controller: _deletePasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Cancel deletion.
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Confirm deletion.
                // Call the deleteAccount with the password
                await _deleteAccountWithPassword();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    } else {
      print("No current user to delete");
    }
  }

  Future<void> _deleteAccountWithPassword() async {
    if (_currentUser != null) {
      try {
        // Re-authenticate the user.
        final credential = EmailAuthProvider.credential(
          email: _currentUser!.email!,
          password: _deletePasswordController.text,
        );
        await _currentUser!.reauthenticateWithCredential(credential);

        // Now, delete the user's data from Firestore.
        await fire_base_logic.deleteUserData(_currentUser!.uid);
        // Now, delete the user account.
        await _currentUser!.delete();

        // Clear the password field.
        _deletePasswordController.clear();

        // User account and data should be deleted.
        print("Account deletion successful");
        // Navigate to the sign-in/sign-up screen after deletion.
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthGate()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: ${e.message}')),
          );
        }
      }
    } else {
      print("No current user to delete");
    }
  }

  Future<void> _changePassword() async {
    if (_currentUser != null) {
      try {
        // Re-authenticate the user with the current password.
        final credential = EmailAuthProvider.credential(
          email: _currentUser!.email!,
          password: _oldPasswordController.text,
        );
        await _currentUser!.reauthenticateWithCredential(credential);

        // Update the password.
        await _currentUser!.updatePassword(_newPasswordController.text);

        // Clear the password fields.
        _oldPasswordController.clear();
        _newPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect old password.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error changing password: ${e.message}')),
          );
        }
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