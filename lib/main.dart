import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // permet de s'assurer que les widgets sont initialisés
  await Firebase.initializeApp( // permet d'initialiser Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App()); // permet de lancer l'application
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177)
        ),
      ),
      home: const AuthScreen(),
    );
  }
}