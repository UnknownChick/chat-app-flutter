import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( // permet de créer une page
      appBar: AppBar( // permet de créer une barre de navigation
        title: const Text(
          'FlutterChat'
        ),
      ),
      body: const Center(
        child: Text(
          'Connexion réussie'
        ),
      )
    );
  }
}