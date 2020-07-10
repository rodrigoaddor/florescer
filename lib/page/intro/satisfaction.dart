import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:flutter/material.dart';
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
  'Motivado, com significado, propóstito e paz de espírito.',
];

class SatisfactionIntroPage extends StatefulWidget {
  @override
  _SatisfactionIntroPageState createState() => _SatisfactionIntroPageState();
}

class _SatisfactionIntroPageState extends State<SatisfactionIntroPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  List<int> answers;
  bool started = false;

  @override
  void initState() {
    super.initState();

    answers = List<int>.generate(questions.length, (_) => 5);
    tabController = TabController(length: questions.length, vsync: this);
  }

  Future<void> save() async {
    final userID = context.read<AppData>().user.id;
    await db.collection('users').document(userID).setData({
      'satisfaction': answers.reduce((a, b) => a + b),
    }, merge: true);
  }

  void handleNext(int answer) async {
    if (tabController.index >= tabController.length - 1) {
      save();
      Navigator.pushNamedAndRemoveUntil(context, '/intro/result', ModalRoute.withName('/intro/categories'));
    } else {
      answers[tabController.index] = answer;
      tabController.animateTo(tabController.index + 1);
      this.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            SizedBox(height: 32),
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
            SizedBox(height: 32),
            !started
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Para o próximo passo, indique seu grau de concordância '
                          'com cada uma das afirmações a seguir.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 64),
                      RaisedButton(
                        child: Text('Continuar'),
                        onPressed: () => this.setState(() => started = true),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                      )
                    ],
                  )
                : Expanded(
                    child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (int i = 0; i < questions.length; i++)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  questions[i],
                                  textAlign: TextAlign.center,
                                  style: texts.bodyText1.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 32),
                              IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (final entry in answerTexts.asMap().entries)
                                      OutlineButton(
                                        color: Colors.white,
                                        child: Text(
                                          entry.value,
                                          style: texts.bodyText2.copyWith(color: Colors.white),
                                        ),
                                        onPressed: () => this.handleNext(entry.key),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                                        borderSide: BorderSide(color: Colors.white38),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                ),
                              )
                              // Slider(
                              //   onChanged: (double value) => this.setState(() => answers[i] = value.toInt()),
                              //   value: answers[i].toDouble(),
                              //   min: 0,
                              //   max: 10,
                              //   divisions: 10,
                              //   label: getLabel(answers[i]),
                              //   onChangeStart: (_) => this.setState(() => selecting = true),
                              //   onChangeEnd: (_) => this.setState(() => selecting = false),
                              // ),
                            ],
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
