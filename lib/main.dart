import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YummyNotes',
      debugShowCheckedModeBanner: false,
      theme: cutePastelTheme,
      home:
          FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const HomeScreen(),
    );
  }
}
