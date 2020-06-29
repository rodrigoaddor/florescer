import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/models/category.dart';
import 'package:florescer/data/data.dart';
import 'package:florescer/data/models/user.dart';

final db = Firestore.instance;

Future<AppData> loadFromFirebase(String userID) async {
  final data = AppData();

  db.collection('categories').snapshots().listen((snapshot) {
    data.categories = snapshot.documents
        .map((doc) => {...doc.data, 'id': doc.documentID})
        .map((doc) => QuestionCategory.fromJson(doc))
        .toList(growable: false);
  });

  db.collection('users').document(userID).snapshots().listen((doc) {
    if (doc.exists)
      data.user = UserData.fromJson({...doc.data, 'id': userID});
    else
      data.user = UserData(id: userID);
  });

  return data;
}
