import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  //using a key will make sure that Flutter can efficiently and correctly re-render the messages list  
  final Key key;

  MessageBubble(this.message, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: !isMe
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isMe? Radius.circular(15) : Radius.circular(0),
              bottomRight: !isMe? Radius.circular(15) : Radius.circular(0),

            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style:
                TextStyle(color: Theme.of(context).accentTextTheme.title.color),
          ),
        ),
      ],
    );
  }
}
