import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/widget/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<String> messages = [
  'Para passarmos para o próximo passo, te apresento alguns pilares '
      'importantes da nossa vida, áreas que são fundamentais para '
      'atingirmos o nosso equilíbrio.',
  'A Roda da Vida ilustra graficamente qual área de vida temos maior '
      'insatisfação no momento presente, o que serve como um guia para '
      'tomada de decisão de onde devemos priorizar nossas ações.',
  'As ações focadas na área com maior insatisfação vão refletir em '
      'ganhos nesse eixo, ao resolver essa deficiência a tendência é '
      'que o grau de insatisfação em todas as demais áreas também '
      'melhore, pois todas as áreas estão conectadas.',
  'Quanto mais simétrico o desenho mais equilibrado está a sua vida.',
  'Esse foi um diagnóstico inicial do mapa de sua vida, '
      'uma ferramenta de auto-conhecimento.',
];

class CategoriesIntroPage extends StatelessWidget {
  void askRedoCategory(BuildContext context, QuestionCategory category) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Você já respondeu esse pilar',
        body: 'Tem certeza que deseja respondê-lo de novo?',
        confirmText: 'Continuar',
      ),
    );

    if (confirmed) Navigator.pushNamed(context, '/category/${category.id}');
  }

  String diagnostic(double value) {
    if (value < 2) {
      return 'Extremamente insatisfeito';
    } else if (value < 4) {
      return 'Insatisfeito';
    } else if (value < 6) {
      return 'Pouco satisfeito';
    } else if (value < 8) {
      return 'Satisfeito';
    } else {
      return 'Extremamente satisfeito';
    }
  }

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
            color: Colors.greenAccent[700],
            padding: const EdgeInsets.only(left: 16, right: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
            onPressed: () => this.askRedoCategory(context, category),
          );
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
                  text: messages[0],
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
                          Navigator.pushNamed(context, '/intro/satisfaction');
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
