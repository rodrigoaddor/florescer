import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final db = Firestore.instance;

final emailRegex = RegExp(
    r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class RegisterIntroPage extends StatefulWidget {
  @override
  _RegisterIntroPageState createState() => _RegisterIntroPageState();
}

class _RegisterIntroPageState extends State<RegisterIntroPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();

  String validateRequired(String value) => value.length > 0 ? null : 'Campo obrigatório';
  String validateEmail(String value) =>
      this.validateRequired(value) ?? (emailRegex.hasMatch(value) ? null : 'Email inválido');

  void register(BuildContext context) async {
    if (!Form.of(context).validate()) return;

    await db.collection('users').document(context.read<AppData>().user.id).setData({
      'name': name.text,
      'email': email.text,
      'city': city.text,
      'state': state.text,
    }, merge: true);

    Navigator.pushReplacementNamed(context, '/intro/categories');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('Cadastro'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: name,
                      autovalidate: name.text.length > 0,
                      validator: this.validateRequired,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                        labelText: 'Nome',
                        helperText: '',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: email,
                      autovalidate: email.text.length > 0,
                      validator: this.validateEmail,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                        labelText: 'Email',
                        helperText: '',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            controller: city,
                            autovalidate: city.text.length > 0,
                            validator: this.validateRequired,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                              ),
                              labelText: 'Cidade',
                              counterText: '\n',
                              helperText: '\n',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: state,
                            autovalidate: state.text.length > 0,
                            validator: this.validateRequired,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                              ),
                              labelText: 'Estado',
                              helperText: '\n',
                              errorMaxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: RaisedButton(
                      onPressed: () => this.register(context),
                      child: Text('Continuar'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
