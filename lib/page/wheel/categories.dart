import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WheelCategoriesPage extends StatelessWidget {
  Widget buildCategoryButton(BuildContext context, QuestionCategory category, [bool isAnswered = false]) {
    return !isAnswered
        ? RaisedButton(
            child: Text(
              category.shortTitle,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
            onPressed: () => Navigator.pushNamed(context, '/category/${category.id}'),
          )
        : RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.shortTitle),
                const SizedBox(width: 8),
                Icon(Icons.check),
              ],
            ),
            disabledColor: Colors.greenAccent[700],
            disabledTextColor: Colors.black45,
            padding: const EdgeInsets.only(left: 16, right: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
            // Allows for a question to be re-answered
            onPressed: () => Navigator.pushNamed(context, '/category/${category.id}'),
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;
    final data = context.watch<AppData>();

    return Scaffold(
      backgroundColor: theme.primaryColor,
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
                  style: texts.bodyText1.copyWith(fontSize: 16),
                  text: 'Para passarmos para o próximo passo, te apresento alguns pilares '
                      'importantes da nossa vida, áreas que são fundamentais para '
                      'atingirmos o nosso equilíbrio.',
                ),
              ),
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final category in data.categories)
                    buildCategoryButton(
                      context,
                      category,
                      data.user.answers != null && data.user.answers.containsKey(category.id),
                    ),
                  if (data.user.answers != null && data.user.answers.length == data.categories.length)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RaisedButton(
                        child: Text(
                          'Continuar',
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/wheel/result');
                          // final reset = await showDialog(
                          //   context: context,
                          //   builder: (context) => ConfirmDialog(title: 'Resetar respostas'),
                          // );
                          // if (reset) {
                          //   final db = Firestore.instance;
                          //   await db.collection('users').document(data.user.id).setData({
                          //     'answers': {},
                          //   }, merge: true);
                          // }
                        },
                      ),
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
