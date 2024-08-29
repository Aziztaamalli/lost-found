// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class ProfilePage extends StatelessWidget {
//   final VoidCallback toggleTheme;

//   const ProfilePage({super.key, required this.toggleTheme});

//   Future<void> _logout(BuildContext context) async {
//     try {
//       // Sign out from Firebase
//       await FirebaseAuth.instance.signOut();

//       // Sign out from Google if GoogleSignIn is used
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       await googleSignIn.signOut();

//       // Navigate back to the login page
//       Navigator.pushReplacementNamed(
//           context, '/login'); // Ensure '/login' is defined in your routes
//     } catch (e) {
//       print('Logout failed: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Logout failed. Please try again.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const ListTile(
//               leading: Icon(Icons.person),
//               title: Text('User Name'),
//               subtitle: Text('user@example.com'),
//             ),
//             const SizedBox(height: 20),
//             SwitchListTile(
//               title: const Text('Dark Mode'),
//               value: Theme.of(context).brightness == Brightness.dark,
//               onChanged: (value) {
//                 toggleTheme();
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _logout(context),
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'custom_bottom_navigation_bar.dart'; // Import the custom bottom navigation bar

class ProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ProfilePage({super.key, required this.toggleTheme});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email;
        });
      }
    } catch (e) {
      print('Failed to fetch user email: $e');
    }
  }

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
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Name'),
              subtitle: Text(_userEmail ?? 'Loading...'),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                widget.toggleTheme();
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        toggleTheme: widget.toggleTheme,
      ),
    );
  }
}
