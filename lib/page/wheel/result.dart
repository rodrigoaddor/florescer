import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/utils/extensions.dart' show ListAverage;
import 'package:florescer/widget/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _colors = {
  'Pessoal': Colors.purple[700],
  'Profissional': Colors.amber[500],
  'Relacional': Colors.teal[600],
  'Emocional': Colors.lightBlue[300],
};

class WheelResultPage extends StatefulWidget {
  @override
  _WheelResultPageState createState() => _WheelResultPageState();
}

class _WheelResultPageState extends State<WheelResultPage> {
  String category;
  bool showQuestion = false;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppData>();
    final theme = Theme.of(context);
    final texts = theme.textTheme;

    final selectedCategory = category == null ? null : data.categories.firstWhere((element) => element.id == category);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Text(selectedCategory?.shortTitle ?? 'Roda da Vida', key: ValueKey(category ?? 'Roda da vida')),
        ),
        leading: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: category == null
              ? SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => this.setState(() => category = null),
                ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WheelOfLife(
                  Map.fromEntries(
                    (category == null
                            ? data.categories
                            : data.categories.firstWhere((item) => item.id == category).questionDescriptions)
                        .map(
                      (item) {
                        if (category == null) {
                          final i = item as QuestionCategory;
                          return MapEntry<String, double>(
                            i.shortTitle,
                            (data.user.answers[i.id] ?? []).average(),
                          );
                        } else {
                          final description = item as String;
                          final cat = data.categories.firstWhere((item) => item.id == category);
                          return MapEntry<String, double>(
                            description,
                            data.user.answers[cat.id][cat.questionDescriptions.indexOf(description)].toDouble(),
                          );
                        }
                      },
                    ),
                  ),
                  colors: _colors,
                  onPress: (i) {
                    if (category == null) {
                      this.setState(() => category = data.categories[i].id);
                    } else {
                      this.setState(() => category = null);
                    }
                  },
                  defaultColor: category == null ? null : _colors[selectedCategory.shortTitle],
                  defaultTextColor: Colors.white,
                  backgroundColor: Colors.white12,
                ),
                Text(
                  'Clique em uma seção para ver mais',
                  style: texts.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedCrossFade(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  crossFadeState: !showQuestion ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: texts.bodyText2.copyWith(color: Colors.white),
                          text: 'Se sua potuação foi de 0 a 5 em 1 ou mais áreas, procure '
                              'dar atenção imediatamente, traçar planos de ação para sair '
                              'dessa situação, pois poderá afetar um grande número de outras áreas.\n\n'
                              'Pontuações acima de 6, quer dizer que você possui um bom nível de '
                              'satisfação ou equilíbrio nessa área. Porém, é importante dar foco '
                              'naquela área que ficou com pontuação abaixo do nível 5.',
                        )
                      ],
                    ),
                  ),
                  secondChild: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pergunte-se:\n',
                            style: texts.bodyText2.copyWith(color: Colors.white),
                          ),
                          TextSpan(
                              text: 'Qual dessas áreas, ao receber um pouco mais de '
                                  'foco, irá influenciar positivamente um maior número de outras áreas?',
                              style: texts.bodyText1.copyWith(color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              child: Text('Continuar'),
              onPressed: () {
                if (!showQuestion) {
                  this.setState(() => showQuestion = true);
                } else {
                  Navigator.pushNamed(context, '/satisfaction/questions');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
