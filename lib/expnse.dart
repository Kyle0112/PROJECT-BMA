import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetInfo extends StatelessWidget {
  final String documentId;
  GetInfo({required this.documentId});

  var nUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('UserAccounts')
        .doc(myUid)
        .collection('dataInference');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            'amount: ${data['amount']}',
          );
        }
        return Text('loading');
      }),
    );
  }
}
