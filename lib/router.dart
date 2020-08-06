import 'package:florescer/page/admin.dart';
import 'package:florescer/page/end.dart';
import 'package:florescer/page/wheel/category.dart';
import 'package:florescer/page/wheel/categories.dart';
import 'package:florescer/page/intro.dart';
import 'package:florescer/page/login.dart';
import 'package:florescer/page/register.dart';
import 'package:florescer/page/satisfaction/result.dart';
import 'package:florescer/page/satisfaction/questions.dart';
import 'package:florescer/page/wheel/result.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/intro': (context) => IntroPage(),
  '/register': (context) => RegisterPage(),
  '/login': (context) => LoginPage(),
  '/satisfaction/questions': (context) => SatisfactionIntroPage(),
  '/satisfaction/result': (context) => ResultIntroPage(),
  '/wheel/categories': (context) => WheelCategoriesPage(),
  '/wheel/result': (context) => WheelResultPage(),
  '/end': (context) => EndPage(),
  '/admin': (context) => AdminPage(),
};

Route routeGenerator(RouteSettings settings) {
  assert(settings.name.startsWith('/'));
  final split = settings.name.split('/').sublist(1);

  if (split[0] == 'category') {
    return MaterialPageRoute(builder: (context) => CategoryPage(split[1]));
  }

  return null;
}
