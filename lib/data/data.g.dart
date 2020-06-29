// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

class AppData with ChangeNotifier implements _AppData {
  List<QuestionCategory> _categories;
  UserData _user;

  AppData({
    List<QuestionCategory> categories,
    UserData user,
  })  : this._categories = categories,
        this._user = user;

  List<QuestionCategory> get categories =>
      UnmodifiableListView(this._categories);
  set categories(List<QuestionCategory> value) {
    this._categories = value;
    this.notifyListeners();
  }

  UserData get user => this._user;
  set user(UserData value) {
    this._user = value;
    this.notifyListeners();
  }
}
