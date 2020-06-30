import 'package:florescer/page/admin.dart';
import 'package:florescer/page/category.dart';
import 'package:florescer/page/intro/categories.dart';
import 'package:florescer/page/intro/intro.dart';
import 'package:florescer/page/intro/register.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/intro': (context) => IntroPage(),
  '/intro/categories': (context) => CategoriesIntroPage(),
  '/intro/register': (context) => RegisterIntroPage(),
  '/admin': (context) => AdminPage()
};

Route routeGenerator(RouteSettings settings) {
  assert(settings.name.startsWith('/'));
  final split = settings.name.split('/').sublist(1);

  if (split[0] == 'category') {
    return MaterialPageRoute(builder: (context) => CategoryPage(split[1]));
  }

  return null;
}
