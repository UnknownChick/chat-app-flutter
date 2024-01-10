import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void _submit() async{
    final isValid = _form.currentState!.validate(); // permet de vérifier si le formulaire est valide

    if (!isValid) { // permet de vérifier si le formulaire n'est pas valide
      return;
    }

    _form.currentState!.save(); // permet de sauvegarder les données du formulaire

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredMail,
          password: _enteredPassword
        );
        print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredMail,
          password: _enteredPassword,
        );
        print(userCredentials);
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
                          ElevatedButton( // permet de créer un bouton
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom( // permet de modifier le style du bouton
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // permet de modifier la couleur du texte
                            ),
                            child: Text(_isLogin ? 'Connexion' : 'S\'inscrire'),
                          ),
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