import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        //primaryColor: Colors.teal ,
        primarySwatch: Colors.teal,
        backgroundColor: Colors.teal,
        accentColor: Colors.blueGrey,
        //let Flutter know that deepPurple is very dark color and that and contrasting color on this
        //purple background should be bright
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.teal,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged, //takes care of token, log in log out, and even cache token for app restarts 
        builder: (context, snapshot) {
          if (snapshot.hasData) //if it has a token then we're logged in 
            return ChatScreen();
          else
            return AuthScreen();
        },
      ),
    );
  }
}
