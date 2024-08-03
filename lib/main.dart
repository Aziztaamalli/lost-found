import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart'; // Import HomePage
// import 'profile_page.dart'; // Import ProfilePage
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 183, 58, 64)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: LoginPage(
        onLoginSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(toggleTheme: _toggleTheme),
            ),
          );
        },
        toggleTheme: () {},
      ),
    );
  }
}
