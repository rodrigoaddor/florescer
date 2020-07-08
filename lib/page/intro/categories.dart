import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/widget/confirm_dialog.dart';
import 'package:florescer/widget/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:florescer/utils/extensions.dart' show ListAverage;

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
            data.user.answers == null || data.user.answers.length == 0
                ? SizedBox.fromSize(
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
                  )
                : WheelOfLife(
                    Map.fromEntries(
                      data.categories.map(
                        (category) => MapEntry<String, double>(
                          category.shortTitle,
                          (data.user.answers[category.id] ?? []).average(),
                        ),
                      ),
                    ),
                    colors: {
                      'Emocional': Colors.lightBlue[300],
                      'Profissional': Colors.amber[500],
                      'Relacional': Colors.teal[600],
                      'Pessoal': Colors.purple[700],
                    },
                    defaultTextColor: Colors.white,
                    backgroundColor: Colors.white12,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 16),
                  text: messages[data.user.answers.length],
                ),
              ),
            ),
            if (data.user.answers != null && data.user.answers.length == data.categories.length)
              Builder(builder: (context) {
                final average = data.user.answers.values.expand<num>((i) => i).toList().average();
                return Text(
                  'Diagnóstico: ${average.toStringAsFixed(0)}/10\n${diagnostic(average)}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                );
              }),
            data.user.answers == null || data.user.answers.length != data.categories.length
                ? IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final category in data.categories)
                          buildCategoryButton(
                            context,
                            category,
                            data.user.answers != null && data.user.answers.containsKey(category.id),
                          )
                      ],
                    ),
                  )
                : RaisedButton(
                    child: Text(
                      'Concluído',
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                    onPressed: () async {
                      final reset = await showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(title: 'Resetar respostas'),
                      );
                      if (reset) {
                        final db = Firestore.instance;
                        await db.collection('users').document(data.user.id).setData({
                          'answers': {},
                        }, merge: true);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
