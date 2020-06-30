import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

final db = Firestore.instance;

class CategoryPage extends StatefulWidget {
  final String id;

  CategoryPage(this.id);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  QuestionCategory category;
  List<int> answers;
  bool selecting = false;

  @override
  void initState() {
    super.initState();

    category = context.read<AppData>().categories.singleWhere((category) => widget.id == category.id);
    answers = List<int>.generate(category.questions.length, (_) => 5);
    tabController = TabController(length: category.questions.length, vsync: this);
  }

  void handlePrevious() async {
    if (tabController.index > 0) {
      tabController.animateTo(tabController.index - 1);
      this.setState(() {});
    }
  }

  void handleNext() async {
    if (tabController.index >= tabController.length - 1) {
      BuildContext dialogContext;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return AlertDialog(
            title: Text('Salvando respostas...'),
            content: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      );

      await Future.wait([
        save(),
        Future.delayed(Duration(seconds: 1)),
      ]);

      Navigator.pop(dialogContext);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Perguntas concluídas'),
          actions: [
            FlatButton(
              child: Text('Voltar ao início'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      tabController.animateTo(tabController.index + 1);
      this.setState(() {});
    }
  }

  Future<void> save() async {
    print(category.id.runtimeType);
    await db.collection('users').document(context.read<AppData>().user.id).setData({
      'answers': {
        category.id: answers
      },
    }, merge: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(category.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            SizedBox.fromSize(
              size: Size.square(200),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.purple[300],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pergunta ',
                  style: texts.headline5,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    '${tabController.index + 1}',
                    key: ValueKey(tabController.index),
                    style: texts.headline5,
                  ),
                  transitionBuilder: (widget, animation) => SlideTransition(
                    position: Tween(
                      begin: Offset(.4, 0) *
                          ((widget.key as ValueKey).value == tabController.index ? 1 : -1) *
                          (tabController.previousIndex < tabController.index ? 1 : -1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: widget,
                    ),
                  ),
                ),
                Text(
                  ' de ${tabController.length}',
                  style: texts.headline5,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < category.questions.length; i++)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            category.questions[i],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32),
                        AnimatedOpacity(
                          opacity: selecting ? 0 : 1,
                          duration: Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Totalmente Insatisfeito', style: texts.caption),
                                Text('Totalmente Satisfeito', style: texts.caption),
                              ],
                            ),
                          ),
                        ),
                        Slider(
                          onChanged: (double value) => this.setState(() => answers[i] = value.toInt()),
                          value: answers[i].toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: answers[i].toString(),
                          onChangeStart: (_) => this.setState(() => selecting = true),
                          onChangeEnd: (_) => this.setState(() => selecting = false),
                        ),
                        AnimatedOpacity(
                          opacity: selecting ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Totalmente Insatisfeito', style: texts.caption),
                                Text('Totalmente Satisfeito', style: texts.caption),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    color: theme.primaryColor,
                    textColor: Colors.white,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        tabController.index >= tabController.length - 1 ? 'Finalizar' : 'Próxima pergunta',
                        key: ValueKey('bnt-${tabController.index >= tabController.length - 1}'),
                      ),
                    ),
                    onPressed: this.handleNext,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
                  ),
                  SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: tabController.index > 0 ? 1 : 0,
                    duration: Duration(milliseconds: 200),
                    child: OutlineButton(
                      child: Text('Pergunta anterior'),
                      onPressed: tabController.index > 0 ? this.handlePrevious : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
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
