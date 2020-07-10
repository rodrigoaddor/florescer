import 'package:florescer/data/data.dart';
import 'package:florescer/widget/wheel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:florescer/utils/extensions.dart' show ListAverage;

final List<String> satisfactionTexts = [
  'Extremamente infeliz. Sentem-se infelizes com tudo, indicando desequilibrio '
      'em diversas áreas de sua vida, nesse caso é indicado a ajuda de um '
      'especialista imediatamente.',
  'Sentem-se substancialmente insatisfeitas com suas vidas, podem estar mal em '
      '1 ou mais áreas da vida. Nesse caso se a insatisfação for uma resposta a um '
      'grave evento recente (divorcio, falecimento, demissão...) é provavel que com '
      'o tempo, retornem a seus níveis anterior de satisfação. Entretanto, se a '
      'insatisfação for crônica, mudanças se fazem necessárias- tanto nas atitudes '
      'quanto nos padrões mentais e atividades diárias. Nesta faixa, a pessoa pode '
      'estar funcionando bem porque a infelicidade atua como uma distração. Embora '
      'a mudança positiva dependa sempre da pessoa. A ajuda de um especialista '
      'poderá fundamental.',
  'Pouco satisfeito. Pessoas que pontuam nesta faixa geralmente possuem problemas '
      'pequenos, porém significativos, problemas em diversas áreas de suas vidas. Ou '
      'então, estão bem em diversas áreas, mas possuem uma área que representa um '
      'problema susbstacial para elas.',
  'De satisfeito a extremamente satisfeito. As pessoas que estão na faixa acima '
      'de 20 pontos, estão caminhando para a busca de uma maior significado de vida '
      'e que muitas coisas estão indo muito bem em sua vida, sente uma motivação e '
      'uma votade imensa de vencer. Para a maioria das pessoas que estão nessa faixa, '
      'percebe a vida como prazerosa e os principais dominios de suas existências '
      'funcionam a contento: Trabalho, família, relacionamentos, saúde, qualidade de '
      'vida, espiritualidade e paz de espírito.'
];

class ResultIntroPage extends StatelessWidget {
  String getSatisfactionText(int i) {
    int index;
    if (i <= 9) {
      index = 0;
    } else if (i <= 14) {
      index = 1;
    } else if (i <= 19) {
      index = 2;
    } else {
      index = 3;
    }
    return satisfactionTexts[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;
    final data = context.watch<AppData>();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WheelOfLife(
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    if (data.user.answers.values.any((i) => i.average() < 6))
                      TextSpan(
                        style: texts.bodyText2.copyWith(color: Colors.white),
                        text: 'Se sua potuação foi de 0 a 5 em 1 ou mais áreas, procure '
                            'dar atenção imediatamente, traçar planos de ação para sair '
                            'dessa situação, pois poderá afetar um grande números de outras áreas.\n\n'
                            'Pontuações acima de 6, quer dizer que você possui um bom nível de '
                            'satisfação ou equilíbrio nessa área, porém importante dar foco '
                            'naquela área que ficou com pontuação abaixo do nível 5.\n\n\n',
                      ),
                    TextSpan(
                      style: texts.headline6.copyWith(color: Colors.white),
                      text: 'Satisfação: ${data.user.satisfaction}/35\n\n',
                    ),
                    TextSpan(
                      style: texts.bodyText2.copyWith(color: Colors.white),
                      text: '${this.getSatisfactionText(data.user.satisfaction)}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
