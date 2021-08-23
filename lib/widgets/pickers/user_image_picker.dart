import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final Function imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage()async{
    //need to be updated after migrating flutter and firebase... 
    final pickedImageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150,);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //image prview
        CircleAvatar(
          radius: 40,
           backgroundImage: _pickedImage != null?FileImage(_pickedImage) : null,
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text('add image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
