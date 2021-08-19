import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String password, String username,
      AUTH_MODE authMode, BuildContext ctx) async {
    AuthResult authResult;
    try {
      if (authMode == AUTH_MODE.LOGIN) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //add username to the user that got created 
        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
          'username': username,
          'email': email,
        });
      }
      
    //catch error thrown by firebase for entering an invalid email, short password ...
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) message = err.message;
      //we need to use context of the auth_form widget because 
      //it is the one that have the right scaffold 
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch(err){
        print(err);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm));
  }
}
