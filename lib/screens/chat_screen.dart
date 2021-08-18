import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: 15, itemBuilder: (context, index) => Text('hello world'),),
      
    );
  }
}