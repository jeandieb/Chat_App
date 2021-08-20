
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                      chatSnapshot.data.documents[index]['text'],
                      chatSnapshot.data.documents[index]['username'],
                      futureSnapshot.data.uid ==
                          chatSnapshot.data.documents[index]['userId'],
                          key: ValueKey(chatSnapshot.data.documents[index].documentID,));
                },
              );
            },
          );
        });
  }
}
