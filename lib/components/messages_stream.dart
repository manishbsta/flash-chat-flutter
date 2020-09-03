import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

final currentUser = FirebaseAuth.instance.currentUser.email;

class MessagesStream extends StatelessWidget {
  final FirebaseFirestore firestore;

  MessagesStream({@required this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messagesWidgets = [];

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          final messages = snapshot.data.docs.reversed;

          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final messageWidget = MessageBubble(
              messageText: messageText,
              messageSender: messageSender,
              isMe: currentUser == messageSender,
            );

            messagesWidgets.add(messageWidget);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: messagesWidgets,
          ),
        );
      },
    );
  }
}
