import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/utils/input.dart';
import 'package:florescer/utils/loading.dart';
import 'package:florescer/widget/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

final db = Firestore.instance;
final auth = FirebaseAuth.instance;

enum ProviderLogin { Google, Facebook }

final Map<String, String> errorMessages = {
  'ERROR_WEAK_PASSWORD': 'A senha é muito fraca.',
  'ERROR_INVALID_EMAIL': 'O email é inválido.',
  'ERROR_EMAIL_ALREADY_IN_USE': 'O email já está cadastrado.',
};

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  ProviderLogin providerLogin;
  String passwordError = '';

  String validatePassword(String _) {
    if (password.text.length < 8) {
      this.setState(() => passwordError = 'A senha deve ter mais de 8 caracteres');
      return '';
    } else if (password.text != passwordConfirm.text) {
      this.setState(() => passwordError = 'As senhas não coincidem');
      return '';
    } else {
      this.setState(() => passwordError = '');
      return null;
    }
  }

  void signInWithGoogle(BuildContext context) {
    showLoadingModal(context, () async {
      final account = await GoogleSignIn(scopes: ['profile', 'email']).signIn();
      if (account != null) {
        final googleAuth = await account.authentication;
        final authResult = await auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
        this.setState(() => providerLogin = ProviderLogin.Google);
        name.text = authResult.user.displayName;
        email.text = authResult.user.email;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Não foi possível Entrar com o Google.'),
        ));
      }
    });
  }

  void register(BuildContext context, [bool professional = false]) async {
    if (!Form.of(context).validate()) return;

    if (professional) {
      final confirm = await ConfirmDialog.show(
        context: context,
        title: 'Deseja registrar como um profissional?',
        confirmText: 'Registrar',
      );
      if (!confirm) return;
    }

    if (providerLogin == null) {
      try {
        await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      } on PlatformException catch (e) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro ao criar conta'),
            content: Text(errorMessages.containsKey(e.code) ? errorMessages[e.code] : 'Erro desconhecido.'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }
    }

    final user = context.read<AppData>().user;

    await db.collection('users').document(user.id).setData({
      'name': name.text,
      'email': email.text,
      'phone': phone.text,
      'city': city.text,
      'state': state.text,
      'type': professional ? 'normal' : 'professional'
    }, merge: true);

    Navigator.pushReplacementNamed(context, '/wheel/categories');
  }

  bool doneFromLoginCheck = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bool fromLogin = ModalRoute.of(context).settings.arguments;
    if (fromLogin == true && !doneFromLoginCheck) {
      () async {
        final account = await GoogleSignIn(scopes: ['profile', 'email']).signInSilently();
        if (account != null) {
          final googleAuth = await account.authentication;
          final authResult = await auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );
          this.setState(() => providerLogin = ProviderLogin.Google);
          name.text = authResult.user.displayName;
          email.text = authResult.user.email;
        }
      }();
    }
    doneFromLoginCheck = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar conta'),
        centerTitle: true,
      ),
      body: Form(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RaisedButton.icon(
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                    ),
                    label: Text('Entrar com o Google'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onPressed: providerLogin == null ? () => this.signInWithGoogle(context) : null,
                  ),
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
                TextFormField(
                  controller: name,
                  enabled: providerLogin == null,
                  autovalidate: name.text.length > 0,
                  validator: validateRequired,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      labelText: 'Nome',
                      counterText: '\n'),
                ),
                TextFormField(
                  controller: email,
                  enabled: providerLogin == null,
                  autovalidate: email.text.length > 0,
                  validator: validateEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      labelText: 'Email',
                      counterText: '\n'),
                ),
                TextFormField(
                  controller: phone,
                  autovalidate: phone.text.length > 0,
                  validator: validateRequired,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '(##) #####-####', filter: {'#': RegExp(r'\d')}),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      labelText: 'Celular',
                      counterText: '\n'),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        controller: city,
                        autovalidate: city.text.length > 0,
                        validator: validateRequired,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                          ),
                          labelText: 'Cidade',
                          counterText: '\n',
                          helperText: '\n',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: state,
                        autovalidate: state.text.length > 0,
                        validator: validateRequired,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                          ),
                          labelText: 'Estado',
                          counterText: '\n',
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  child: providerLogin != null
                      ? SizedBox.shrink()
                      : Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: password,
                                    validator: this.validatePassword,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
                                      ),
                                      labelText: 'Senha',
                                      helperText: '',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: passwordConfirm,
                                    validator: this.validatePassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                                      ),
                                      labelText: 'Confirmar',
                                      helperText: '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  passwordError,
                                  key: ValueKey('text-$passwordError'),
                                  style: texts.caption.copyWith(color: theme.errorColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RaisedButton(
                    onPressed: () => this.register(context),
                    child: Text('Registrar'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    color: theme.colorScheme.primary,
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: RaisedButton(
                    onPressed: () => this.register(context, true),
                    child: Text('Registrar como Profissional'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
