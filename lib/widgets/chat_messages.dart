import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder( // permet de créer un stream pour le message
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: false).snapshots(), // permet de créer une collection pour le message
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
          // reverse: true,
          itemCount: loadedMessages.length,
          // itemBuilder: (ctx, index) => MessageBubble( // permet de créer un contexte pour le message
          //   message: loadedMessages[index]['text'],
          //   username: loadedMessages[index]['username'],
          //   userImage: loadedMessages[index]['userImage'],
          //   isMe: loadedMessages[index]['userId'] == chatSnapshot.data!.docs[index]['userId'],
          //   key: ValueKey(loadedMessages[index].id),
          // ),
          itemBuilder: (ctx, index) => Text(
            loadedMessages[index].data()['text'],
          ),
        );
      },
    );
  }
}