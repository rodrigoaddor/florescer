import 'dart:collection';

import 'package:florescer/data/models/category.dart';
import 'package:florescer/data/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:state_gen/annotations.dart';

part 'data.g.dart';

@store
class _AppData with ChangeNotifier {
  List<QuestionCategory> categories;
  UserData user;
}
