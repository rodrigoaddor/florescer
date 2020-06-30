import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/data/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesIntroPage extends StatelessWidget {
  void saveAndRegister(BuildContext context, QuestionCategory category) {
    final state = context.read<AppState>();
    final data = context.read<AppData>();
    state.category = category.id;

    Navigator.pushNamed(context, data.user.isRegistered ? '/category/${state.category}' : '/intro/register');
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox.fromSize(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 16),
                  text: 'Para passarmos para o próximo passo, te apresento '
                      'alguns pilares importantes da nossa vida, áreas que '
                      'são fundamentais para atingirmos o nosso equilíbrio.',
                ),
              ),
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final category in data.categories)
                    RaisedButton(
                      onPressed: () => this.saveAndRegister(context, category),
                      child: Text(
                        category.shortTitle,
                        textAlign: TextAlign.center,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
