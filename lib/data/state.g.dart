// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

class AppState with ChangeNotifier implements _AppState {
  String _category;

  AppState({
    String category,
  }) : this._category = category;

  factory AppState.fromSharedPrefs(SharedPreferences prefs) => AppState(
        category:
            prefs.containsKey('category') ? prefs.getString('category') : null,
      );

  String get category => this._category;
  set category(String value) {
    this._category = value;
    this.notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('category', value));
  }
}
