import 'package:chat_app/widgets/messages_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!; // permet de créer une variable pour l'utilisateur

    return StreamBuilder( // permet de créer un stream pour le message
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(), // permet de créer une collection pour le message
      builder: (ctx, chatSnapshot) { // permet de créer un contexte pour le message
        if (chatSnapshot.connectionState == ConnectionState.waiting) { // permet de vérifier si le message est en attente
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) { // permet de vérifier si le message est vide
          return const Center(
            child: Text(
              'Aucun message trouvé'
            ),
          );
        }

        if (chatSnapshot.hasError) { // permet de vérifier si le message contient une erreur
          return const Center(
            child: Text(
              'Une erreur est survenue'
            ),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs; // permet de créer une variable pour le message

        return ListView.builder( // permet de créer une liste pour le message
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data(); // permet de créer une variable pour le message
            final nextChatMessage = index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null; // permet de créer une variable pour le message suivant

            final currentMessageUserId = chatMessage['userId']; // permet de créer une variable l'utilisateur du message
            final nextMessageUserId = nextChatMessage != null ? nextChatMessage['userId'] : null; // permet de créer une variable pour l'utilisateur du message suivant
            final nextUserIsSame = nextMessageUserId == currentMessageUserId; // permet de vérifier si l'utilisateur du message suivant est le même que l'utilisateur du message

            if (nextUserIsSame) { // permet de vérifier si l'utilisateur du message suivant est le même que l'utilisateur du message
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                message: chatMessage['text'],
                username: chatMessage['username'],
                userImage: chatMessage['userImage'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}