import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.onPickImage}) : super(key: key);

  final void Function(File pickedImage) onPickImage; // permet de créer une fonction pour l'image

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async { // permet de créer une fonction pour choisir une image
    final pickedImage = await ImagePicker().pickImage( // permet de créer une variable pour l'image
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150
    );

    if (pickedImage == null) { // permet de vérifier si l'image est nulle
      return;
    }
    
    setState(() { // permet de créer un état pour l'image
      _pickedImageFile = File(pickedImage.path); // permet de créer une variable pour l'image
    }); // permet de choisir une image

    widget.onPickImage(_pickedImageFile!); // permet de créer une fonction pour l'image
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar( // permet de créer un avatar
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon( // permet de créer un bouton
          onPressed: _pickImage, // permet de créer une action pour le bouton
          icon: const Icon(
            Icons.image,
          ),
          label: Text(
            'Ajouter une image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )
          ),
        ),
      ],
    );
  }
}