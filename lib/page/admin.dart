import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florescer/data/models/user.dart';
import 'package:flutter/material.dart';

final db = Firestore.instance;

enum GroupBy { questions, users }
final Map<GroupBy, String> groupByStr = {
  GroupBy.questions: 'questões',
  GroupBy.users: 'usuários',
};

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var groupBy = GroupBy.questions;
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

  void toggleGroupBy(BuildContext context) {
    int i = this.groupBy.index + 1;
    i = i >= GroupBy.values.length ? 0 : i;
    this.setState(() => groupBy = GroupBy.values[i]);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Agrupando por ${groupByStr[this.groupBy]}'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respostas'),
        // actions: [
        //   Builder(
        //     builder: (context) => IconButton(
        //       icon: Icon(Icons.filter_list),
        //       onPressed: () => this.toggleGroupBy(context),
        //     ),
        //   ),
        // ],
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
                              '${answer.value.asMap().map((i, v) => MapEntry(i, '${questions[answer.key]['questions'][i]} - $v')).values.join('\n')}'),
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
