import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //StreamBuilder is a live listener to changes of values on firebase database,
      //builder of StreamBuilder takes the code we need to rebuild once a value changes
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/VcI6P5yUDksHpGUitH3D/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final documents = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => Text(documents[index]['text']),
            );
          }),
          floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){
            //the next line adds a new DOCUMENT to firebase 
            Firestore.instance.collection('chats/VcI6P5yUDksHpGUitH3D/messages').add({
              'text': 'This was added by clicking the button'
            });
          },),
    );
  }
}
