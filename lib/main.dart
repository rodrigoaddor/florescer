import 'package:firebase_auth/firebase_auth.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/data/firebase.dart';
import 'package:florescer/data/state.dart';
import 'package:florescer/router.dart';
import 'package:florescer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final user = (await auth.signInAnonymously()).user;

  final appData = await loadFromFirebase(user.uid);
  final appState = AppState.fromSharedPrefs(prefs);

  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider.value(value: appData),
    ChangeNotifierProvider.value(value: appState),
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: FlorescerApp(),
    ),
  );
}

class FlorescerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Florescer',
      routes: routes,
      initialRoute: context.watch<AppData>().user.isRegistered ? '/intro/categories' : '/intro',
      theme: buildTheme(),
      onGenerateRoute: routeGenerator,
    );
  }
}
