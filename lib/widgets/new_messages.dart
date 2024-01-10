import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() { // permet de supprimer le message
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() { // permet de créer une fonction pour envoyer le message
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    _messageController.clear(); // permet de supprimer le message
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Envoyer un message',
              ),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(
              Icons.send,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),],
      ),
    );
  }
}