import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance; // permet de créer une instance de Firebase

class AuthScreen extends StatefulWidget { // permet de créer un état pour la page
  const AuthScreen({Key? key}) : super(key: key); // permet de créer une clé pour la page

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>(); // permet de créer une clé pour le formulaire
  var _isLogin = true; // permet de créer une variable pour le chargement
  var _enteredMail = ''; // permet de créer une variable pour le mail
  var _enteredPassword = ''; // permet de créer une variable pour le mot de passe
  var _enteredUsername = ''; // permet de créer une variable pour le pseudo
  File? _selectedImage; // permet de créer une variable pour l'image
  var _isAuthenticating = false; // permet de créer une variable pour le chargement

  void _submit() async{
    final isValid = _form.currentState!.validate(); // permet de vérifier si le formulaire est valide

    if (!isValid || !_isLogin && _selectedImage == null) { // permet de vérifier si le formulaire n'est pas valide
      return;
    }

    _form.currentState!.save(); // permet de sauvegarder les données du formulaire

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredMail,
          password: _enteredPassword
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredMail,
          password: _enteredPassword,
        );
        final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredentials.user!.uid}.jpg'); // permet de créer un dossier pour l'image

        await storageRef.putFile(_selectedImage!); // permet de créer un dossier pour l'image
        final imageUrl = storageRef.getDownloadURL();
        String resolvedImageUrl = await imageUrl;
        
        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({ // permet de créer un dossier pour l'image
          'username': _enteredUsername,
          'email': _enteredMail,
          'image_url': resolvedImageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        
      }
      ScaffoldMessenger.of(context).clearSnackBars(); // permet de supprimer les messages d'erreur
      ScaffoldMessenger.of(context).showSnackBar( // permet d'afficher un message d'erreur
        SnackBar(
          content: Text(error.message ?? 'Une erreur est survenue'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // permet de créer une page
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // permet de centrer les éléments
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView( // permet de scroller dans le formulaire
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form, // permet de lier la clé au formulaire
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // permet de réduire la taille du formulaire
                        children: [
                          if (!_isLogin) UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage; // permet de créer une variable pour l'image
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Pseudo',
                              ),
                              enableSuggestions: false, // pas de suggestion
                              validator: (value) {
                                if (value == null || value.isEmpty || value.trim().length < 4) { // permet de vérifier si le champ est vide ou si il contient moins de 4 caractères
                                  return 'Le pseudo doit contenir au moins 4 caractères';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!; // permet de sauvegarder la valeur du champ
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress, // permet de faire apparaitre le clavier adapté avec un @
                            autocorrect: false, // pas de correction automatique
                            textCapitalization: TextCapitalization.none, // pas de majuscule
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) { // permet de vérifier si le champ est vide ou si il contient un @
                                return 'Veuillez entrer une adresse email valide';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredMail = value!; // permet de sauvegarder la valeur du champ
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                            ),
                            obscureText: true, // permet de cacher le mot de passe
                            validator: (value) {
                              if (value == null || value.trim().length < 6) { // permet de vérifier si le champ est vide ou si il contient moins de 6 caractères
                                return 'Le mot de passe doit contenir au moins 6 caractères';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!; // permet de sauvegarder la valeur du champ
                            },
                          ),
                          const SizedBox(
                            height: 12
                          ),
                          if (_isAuthenticating) // permet de vérifier si le chargement est terminé
                            const CircularProgressIndicator(), // permet de créer un cercle de chargement
                          if (!_isAuthenticating) // permet de vérifier si le chargement est terminé
                            ElevatedButton( // permet de créer un bouton
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom( // permet de modifier le style du bouton
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer, // permet de modifier la couleur du texte
                              ),
                              child: Text(_isLogin ? 'Connexion' : 'S\'inscrire'),
                            ),
                          if (!_isAuthenticating) // permet de vérifier si le chargement est terminé
                            TextButton(
                              onPressed: () {
                                setState(() { // permet de modifier l'état de la page
                                  _isLogin = !_isLogin; // permet de changer le texte du bouton
                                });
                              },
                              child: Text(
                                _isLogin ? 'Créer un compte' : 'J\'ai déjà un compte',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}