import 'package:firebase_auth/firebase_auth.dart';
import 'package:florescer/utils/input.dart';
import 'package:florescer/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final auth = FirebaseAuth.instance;

final Map<String, String> errorMessages = {
  'ERROR_INVALID_EMAIL': 'O email é inválido.',
  'ERROR_WRONG_PASSWORD': 'A senha está incorreta.',
  'ERROR_USER_NOT_FOUND': 'Esse email não está cadastrado.',
  'ERROR_USER_DISABLED': 'Sua conta foi desabilitada.',
  'ERROR_TOO_MANY_REQUESTS': 'Tente novamente mais tarde.',
  'ERROR_OPERATION_NOT_ALLOWED': 'Login temporariamente indisponível.',
};

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = TextEditingController();
  var password = TextEditingController();

  void login(BuildContext context) {
    if (!Form.of(context).validate()) return;

    showLoadingModal(context, () async {
      try {
        await auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
      } on PlatformException catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(errorMessages[e.code]),
        ));
      }
    });
  }

  void signInWithGoogle(BuildContext context) async {
    final route = await showLoadingModal<String>(context, () async {
      final googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      final account = await googleSignIn.signIn();
      if (account != null) {
        final authMethods = await auth.fetchSignInMethodsForEmail(email: account.email);
        if (authMethods.contains('google.com')) {
          final googleAuth = await account.authentication;
          await auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );
          return '/wheel/categories';
        } else {
          return '/register?true';
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Não foi possível Entrar com o Google.'),
        ));
        return null;
      }
    });

    if (route != null) {
      final uri = Uri.parse(route);
      Navigator.pushNamedAndRemoveUntil(
        context,
        uri.path,
        (_) => false,
        arguments: uri.query == 'true',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fazer Login'),
        centerTitle: true,
      ),
      body: Form(
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: email,
                  autovalidate: email.text.length > 0,
                  validator: validateEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      labelText: 'Email',
                      counterText: '\n'),
                ),
                TextFormField(
                  controller: password,
                  autovalidate: password.text.length > 0,
                  validator: validateRequired,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      labelText: 'Senha',
                      counterText: '\n'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RaisedButton(
                    onPressed: () => this.login(context),
                    child: Text('Entrar'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    color: theme.colorScheme.primary,
                    textColor: Colors.white,
                  ),
                ),
                RaisedButton.icon(
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                  ),
                  label: Text('Entrar com o Google'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onPressed: () => this.signInWithGoogle(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RaisedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.facebookF),
                    label: Text('Entrar com o Facebook'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
