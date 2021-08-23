import 'dart:io';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

enum AUTH_MODE { LOGIN, SIGNUP }

class AuthForm extends StatefulWidget {
  final Function _submitForm;
  final bool _isLoading;
  AuthForm(this._submitForm, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AUTH_MODE authMode = AUTH_MODE.LOGIN;

  final _formKey = GlobalKey<FormState>();

  String _emailAddress = '';
  String _username = '';
  String _password = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final _passwordController = TextEditingController();

  void changeAuthMode() {
    setState(() {
      authMode == AUTH_MODE.LOGIN
          ? authMode = AUTH_MODE.SIGNUP
          : authMode = AUTH_MODE.LOGIN;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    //close the soft keyboard when the form is valid and being submitted
    FocusScope.of(context).unfocus();
    //no image was picked
    if (_userImageFile == null && authMode == AUTH_MODE.SIGNUP) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image, '),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      //this reached it will trigger the onSaved property in each TextFormField
      _formKey.currentState.save();
      //get rid of invalid spaces at the begining and end of credentials
      widget._submitForm(_emailAddress.trim(), _password.trim(),
          _username.trim(), _userImageFile, authMode, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisSize: MainAxisSize
                      .min, //make columns take as much space as needed
                  children: [
                    //image
                    if (authMode == AUTH_MODE.SIGNUP) UserImagePicker(_pickedImage),
                    //email
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@'))
                          return 'Please enter a valid email address';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (newValue) => _emailAddress = newValue,
                    ),
                    //username
                    //we need to add akey to each TextFormField so value don't jump to the next Field when one dissapers or is removed
                    if (authMode == AUTH_MODE.SIGNUP)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4)
                            return 'please enter a username long than 4 characters';
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (newValue) => _username = newValue,
                      ),
                    //password
                    TextFormField(
                      key: ValueKey('password'),
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7)
                          return 'Password must be at least 7 characters long';
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (newValue) => _password = newValue,
                    ),
                    //confirm password
                    if (authMode == AUTH_MODE.SIGNUP)
                      TextFormField(
                        key: ValueKey('confPassword'),
                        validator: (value) {
                          if (value.isEmpty ||
                              value != _passwordController.text)
                            return 'password does not match';
                          return null;
                        },
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                      ),
                    SizedBox(height: 15),
                    if (widget._isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!widget._isLoading)
                      RaisedButton(
                        child: Text(
                            authMode == AUTH_MODE.LOGIN ? 'Log In' : 'Sign Up'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget._isLoading)
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(authMode == AUTH_MODE.LOGIN
                              ? 'Create new account'
                              : 'I already have an account'),
                          onPressed: changeAuthMode)
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
