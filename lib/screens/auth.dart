import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget { // permet de créer un état pour la page
  const AuthScreen({Key? key}) : super(key: key); // permet de créer une clé pour la page

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true; // permet de créer une variable pour le chargement

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
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                            ),
                            obscureText: true, // permet de cacher le mot de passe
                          ),
                          const SizedBox(
                            height: 12
                          ),
                          ElevatedButton( // permet de créer un bouton
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom( // permet de modifier le style du bouton
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // permet de modifier la couleur du texte
                            ),
                            child: Text(_isLogin ? 'Connexion' : 'S\'inscrire'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
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