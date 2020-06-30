import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final db = Firestore.instance;

class IntroPage extends StatelessWidget {
  void resetUserData(BuildContext context) async {
    final userID = context.read<AppData>().user.id;
    await db.collection('users').document(userID).setData({'id': userID});
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Reset user data.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Ver Respostas'),
              onTap: () => Navigator.pushNamed(context, '/admin'),
            )
          ],
        ),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onLongPress: () => this.resetUserData(context),
                child: SizedBox.fromSize(
                  size: Size.square(200),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: kElevationToShadow[6],
                      borderRadius: BorderRadius.circular(128),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: [
                          TextSpan(text: 'Olá, eu sou a '),
                          TextSpan(text: 'Florescer', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: ',\na sua assistente virtual.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 16),
                        text: 'Estou aqui para te ouvir e te ajudar a '
                            'resolver situações desafiadoras, bem como comportamentos, sentimentos e '
                            'emoções que você não está conseguindo gerenciar.',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 140,
                height: 40,
                child: RaisedButton(
                  child: Text('Próximo'),
                  onPressed: () => Navigator.pushNamed(context, '/intro/categories'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64),
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
