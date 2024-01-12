import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance; // permet de créer une instance de FirebaseMessaging

    await fcm.requestPermission(); // permet de demander la permission pour les notifications

    final token = await fcm.getToken(); // permet de récupérer le token de l'utilisateur
    print(token);
  }

  @override
  void initState() {
    super.initState();

    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold( // permet de créer une page
      appBar: AppBar( // permet de créer une barre de navigation
        title: Text(
          'FlutterChat - ${authenticatedUser.email}'
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