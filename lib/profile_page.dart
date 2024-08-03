import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const ProfilePage({super.key, required this.toggleTheme});

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google if GoogleSignIn is used
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Navigate back to the login page
      Navigator.pushReplacementNamed(
          context, '/login'); // Ensure '/login' is defined in your routes
    } catch (e) {
      print('Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('User Name'),
              subtitle: Text('user@example.com'),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                toggleTheme();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
