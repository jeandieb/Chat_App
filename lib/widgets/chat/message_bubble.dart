// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;
  //using a key will make sure that Flutter can efficiently and correctly re-render the messages list
  final Key key;

  MessageBubble(this.message, this.username, this.userImage, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(userImage),),
        Container(
          decoration: BoxDecoration(
            color: !isMe
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
              bottomRight: !isMe ? Radius.circular(15) : Radius.circular(0),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              //this work but it's not optimal since we send a request to get username 
              //everytime we create a message bubble
              //a better approch is to add username when creating a new message (to the message data)
              // FutureBuilder(
              //   future: Firestore.instance
              //       .collection('users')
              //       .document(username)
              //       .get(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting)
              //       return Text('loading');
                  //username
                  //return
                   Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
            //    },
             // ),
              //message
              Text(
                message,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.title.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
