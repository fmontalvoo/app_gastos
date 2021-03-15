import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_gastos/src/utils/login_state.dart';

class DetailsScreen extends StatefulWidget {
  final DetailsParams params;

  const DetailsScreen({Key key, this.params}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(builder: (context, loginState, child) {
      var user = context.read<LoginState>().currentUser;
      var stream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .where('month', isEqualTo: widget.params.month)
          .where('category', isEqualTo: widget.params.categoryName)
          .snapshots();

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.params.categoryName),
        ),
        body: _body(stream, user),
      );
    });
  }

  Widget _body(Stream<QuerySnapshot> stream, User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data.docs[index];
              return _dismissable(doc, user);
            },
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _dismissable(QueryDocumentSnapshot doc, User user) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(doc.id),
      background: Container(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 40.0,
          ),
          color: Colors.red),
      child: _item(doc),
      onDismissed: (direction) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .doc(doc.id)
            .delete();
      },
    );
  }

  Widget _item(QueryDocumentSnapshot doc) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 40.0,
          ),
          Positioned(bottom: 8.0, child: Text(doc['day'].toString())),
        ],
      ),
      title: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            "\$${doc['value']}",
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )),
    );
  }
}

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams({this.categoryName, this.month});
}
