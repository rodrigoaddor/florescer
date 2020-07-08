import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/models/user.dart';
import 'package:flutter/material.dart';

final db = Firestore.instance;

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Map<String, Map<String, dynamic>> questions;
  List<UserData> users;

  @override
  void initState() {
    super.initState();

    db.collection('categories').snapshots().listen((snapshot) {
      this.setState(() {
        questions = Map.fromEntries(
          snapshot.documents.map((doc) => MapEntry<String, Map<String, dynamic>>(doc.documentID, doc.data)),
        );
      });
    });

    db.collection('users').snapshots().listen((snapshot) {
      this.setState(() {
        users = snapshot.documents
            .map((doc) => UserData.fromJson({...doc.data, 'id': doc.documentID}))
            .toList(growable: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respostas'),
      ),
      body: users != null && questions != null
          ? ListView(
              children: [
                for (final user in users)
                  ExpansionTile(
                    title: Text('${user.name} (${user.email})'),
                    subtitle: Text('${user.answers.length} resposta(s).'),
                    children: [
                      for (final answer in user.answers.entries)
                        ListTile(
                          title: Text(questions[answer.key]['title']),
                          subtitle: Text(
                            '${answer.value.asMap().map((i, v) => MapEntry(i, '${questions[answer.key]['questions'][i]} - $v')).values.join('\n')}',
                          ),
                          isThreeLine: true,
                        )
                    ],
                  )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
