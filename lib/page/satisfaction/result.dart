import 'package:florescer/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<String> satisfactionTexts = [
  'Extremamente infeliz.\nSentem-se infelizes com tudo, indicando desequilibrio '
      'em diversas áreas de sua vida.\nNesse caso, é indicado a ajuda de um '
      'especialista imediatamente.',
  'Insatisfeito.\nSentem-se substancialmente insatisfeitas com suas vidas, podem estar mal em '
      '1 ou mais áreas da vida.\nNesse caso, se a insatisfação for uma resposta a um '
      'grave evento recente (divorcio, falecimento, demissão...) é provavel que com '
      'o tempo, retornem a seus níveis anterior de satisfação.\nEntretanto, se a '
      'insatisfação for crônica, mudanças se fazem necessárias- tanto nas atitudes '
      'quanto nos padrões mentais e atividades diárias.\nNesta faixa, a pessoa pode '
      'estar funcionando bem porque a infelicidade atua como uma distração. Embora '
      'a mudança positiva dependa sempre da pessoa, a ajuda de um especialista '
      'poderá ser fundamental.',
  'Pouco satisfeito.\nPessoas que pontuam nesta faixa geralmente possuem problemas '
      'pequenos, porém significativos, problemas em diversas áreas de suas vidas. Ou '
      'então, estão bem em diversas áreas, mas possuem uma área que representa um '
      'problema susbstacial para elas.',
  'De satisfeito a extremamente satisfeito.\nAs pessoas que estão na faixa acima '
      'de 20 pontos, estão caminhando para a busca de uma maior significado de vida '
      'e que muitas coisas estão indo muito bem em sua vida, sente uma motivação e '
      'uma votade imensa de vencer.\nPara a maioria das pessoas que estão nessa faixa, '
      'percebe a vida como prazerosa e os principais dominios de suas existências '
      'funcionam a contento: Trabalho, família, relacionamentos, saúde, qualidade de '
      'vida, espiritualidade e paz de espírito.'
];

final List<String> satisfactionEmojis = [
  '😩',
  '😔',
  '😐',
  '😃',
];

class ResultIntroPage extends StatefulWidget {
  @override
  _ResultIntroPageState createState() => _ResultIntroPageState();
}

class _ResultIntroPageState extends State<ResultIntroPage> with SingleTickerProviderStateMixin {
  int getSatisfactionIndex(int i) {
    if (i <= 9) {
      return 0;
    } else if (i <= 14) {
      return 1;
    } else if (i <= 19) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;

    final satisfaction = context.select((AppData data) => data.user.satisfaction);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Satisfação'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                satisfactionEmojis[getSatisfactionIndex(satisfaction)],
                style: texts.headline1.copyWith(color: Colors.black),
              ),
            ),
            Text(
              'Resultado: $satisfaction pontos',
              style: texts.headline6.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text(
                '${satisfactionTexts[getSatisfactionIndex(satisfaction)]}'.replaceAll('\n', '\n\n'),
                style: texts.bodyText2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              child: Text('Próximo'),
              onPressed: () => Navigator.pushNamed(context, '/end'),
            )
          ],
        ),
      ),
    );
  }
}
