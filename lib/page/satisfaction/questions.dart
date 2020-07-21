import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final db = Firestore.instance;

final List<String> questions = [
  'Em muitos aspectos, a minha vida aproxima-se do que eu considero ideal.',
  'Minhas condições de vida são excelentes.',
  'Estou satisfeito com meu momento de vida.',
  'Até agora tenho conseguido as coisas importantes que quero na vida.',
  'Se pudesse viver a minha vida de novo, eu não alteraria praticamente nada.',
];

final List<String> answerTexts = [
  'Extremamente infeliz e insatisfeito.',
  'Infeliz e nível de desiquilibrio.',
  'Percebo algumas oscilações de humor.',
  'Me sinto estático.',
  'Ora me sinto bem, ora não.',
  'Feliz e em busca da motivação.',
  'Motivado, com propósito e paz de espírito.',
];

class SatisfactionIntroPage extends StatefulWidget {
  @override
  _SatisfactionIntroPageState createState() => _SatisfactionIntroPageState();
}

class _SatisfactionIntroPageState extends State<SatisfactionIntroPage> with SingleTickerProviderStateMixin {
  List<TextEditingController> answers;

  @override
  void initState() {
    super.initState();

    answers = List<TextEditingController>.generate(
      questions.length,
      (_) => TextEditingController()..addListener(() => this.setState(() {})),
    );
  }

  Future<void> save() async {
    final userID = context.read<AppData>().user.id;
    await db.collection('users').document(userID).setData({
      'satisfaction': answers.map((controller) => int.parse(controller.text)).reduce((a, b) => a + b),
    }, merge: true);
    Navigator.pushNamed(context, '/satisfaction/result');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;

    return Theme(
      data: theme.copyWith(cursorColor: Colors.white),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Satisfação'),
          centerTitle: true,
        ),
        body: ListView(
          reverse: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          top: BorderSide(color: Colors.white24, width: 2),
                        ).add(
                          Border.symmetric(horizontal: BorderSide(color: Colors.white24, width: 2)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Legenda',
                          style: texts.headline6.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Table(
                    border: TableBorder.all(color: Colors.white24, width: 2),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: IntrinsicColumnWidth(),
                    children: [
                      for (final entry in answerTexts.asMap().entries)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                '${entry.key + 1}',
                                style: texts.bodyText1.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                entry.value,
                                style: texts.bodyText2.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Text(
                'Usando uma escala de 1 a 7, indique seu grau de '
                'concordância com cada uma das afirmações a seguir.',
                style: texts.bodyText1.copyWith(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  for (final entry in questions.asMap().entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 42,
                            child: Center(
                              child: TextFormField(
                                controller: answers[entry.key],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.top,
                                maxLength: 1,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(RegExp(r'[1-7]')),
                                ],
                                style: texts.bodyText1.copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white24),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 2, bottom: 4),
                                  counterText: '',
                                  hintText: '0',
                                  hintStyle: texts.bodyText2.copyWith(color: Colors.white30),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                    top: BorderSide(color: Colors.white24),
                                    bottom: BorderSide(color: Colors.white24),
                                    end: BorderSide(color: Colors.white24),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Center(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        entry.value,
                                        style: texts.bodyText2.copyWith(color: Colors.white),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('Continuar'),
                onPressed: answers.every((controller) => (int.tryParse(controller.text) ?? 0) > 0) ? this.save : null,
              ),
            ),
          ].reversed.toList(growable: false),
        ),
      ),
    );
  }
}
