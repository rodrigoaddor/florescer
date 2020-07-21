import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/data/models/user.dart';
import 'package:florescer/data/state.dart';
import 'package:florescer/router.dart';
import 'package:florescer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:florescer/utils/extensions.dart' show KeySorter;

final db = Firestore.instance;
final auth = FirebaseAuth.instance;

final categoryKeys = [
  'Pessoal',
  'Profissional',
  'Relacional',
  'Emocional',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final appData = AppData();
  final appState = AppState.fromSharedPrefs(prefs);

  db.collection('categories').snapshots().listen((snapshot) {
    appData.categories = snapshot.documents
        .map((doc) => {...doc.data, 'id': doc.documentID})
        .map((doc) => QuestionCategory.fromJson(doc))
        .toList(growable: false)
          ..keySort(
            categoryKeys,
            (entry) => entry.shortTitle,
          );
  });

  StreamSubscription userDataSubscription;
  auth.onAuthStateChanged.listen((user) async {
    userDataSubscription?.cancel();
    if (user != null) {
      appData.user = UserData(id: user.uid);
      userDataSubscription = db.collection('users').document(user.uid).snapshots().listen((doc) {
        if (doc.exists) appData.user = UserData.fromJson({...doc.data, 'id': user.uid});
      });
    } else {
      appData.user = UserData();
    }
  });

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
    final data = context.watch<AppData>();
    return MaterialApp(
      title: 'Florescer',
      routes: routes,
      initialRoute: data.user != null && data.user.isRegistered ? '/wheel/categories' : '/intro',
      theme: buildTheme(),
      onGenerateRoute: routeGenerator,
    );
  }
}
