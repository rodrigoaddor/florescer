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
    final theme = Theme.of(context);
    final texts = theme.textTheme.apply(bodyColor: Colors.white);
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
                        style: texts.headline6,
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
                        style: texts.bodyText1.copyWith(fontSize: 16),
                        text: 'Estou aqui para te ouvir e te ajudar a '
                            'resolver situações desafiadoras, bem como comportamentos, sentimentos e '
                            'emoções que você não está conseguindo gerenciar.',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text('Fazer login'),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text('Criar conta'),
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
