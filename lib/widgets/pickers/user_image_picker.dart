import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final void Function(File pickedImage)imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File? pkdImage;

  void _pickImage()async{
    final picker = ImagePicker();
    final _pickedImage = await picker.pickImage(source: ImageSource.camera,imageQuality: 50, maxHeight: 150);
    final pickedImageFile = File(_pickedImage!.path);

    setState(() {
      pkdImage = pickedImageFile;
    });

    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.indigo,
          backgroundImage: pkdImage != null ? FileImage(pkdImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Add Image",style: TextStyle(color: Colors.lime),),
        ),
      ],
    );
  }
}
