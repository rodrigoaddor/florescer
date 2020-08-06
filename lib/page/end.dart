import 'package:flutter/material.dart';

class EndPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme.apply(bodyColor: Colors.white);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '😉',
              style: texts.bodyText1.copyWith(fontSize: 96),
              textAlign: TextAlign.center,
            ),
            Text(
              'Primeira etapa concluída com sucesso!',
              style: texts.headline6,
              textAlign: TextAlign.center,
            ),
            Text(
              'Seu nível de satisfação com sua vida foi mapeado com sucesso.\n\n'
              'Acesse o botão para continuar as próximas fases.',
              textAlign: TextAlign.center,
              style: texts.bodyText2,
            ),
            RaisedButton(
              child: Text('Continuar'),
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/wheel/categories')),
            ),
          ],
        ),
      ),
    );
  }
}
