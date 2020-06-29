import 'package:flutter/material.dart';
import 'package:state_gen/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'state.g.dart';

@store
class _AppState with ChangeNotifier {
  @shared
  String category;
}
