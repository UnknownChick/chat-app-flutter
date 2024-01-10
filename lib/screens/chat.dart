import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          IconButton(
            onPressed: () { // permet de créer une action pour le bouton
              FirebaseAuth.instance.signOut(); // permet de déconnecter l'utilisateur
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary, // permet de définir la couleur du bouton
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessages()
          ),
          NewMessage(),
        ],
      ),
    );
  }
}