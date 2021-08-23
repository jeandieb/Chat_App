import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File image, AUTH_MODE authMode, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (authMode == AUTH_MODE.LOGIN) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_images').child(
            authResult.user.uid +
                '.jpg'); //usually images taken by device cam are .jpg
        //we use on complelete because it returns a Future and hence we can await it
        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();

        //add username to the user that got created
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
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
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
