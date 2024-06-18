

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetInfo extends StatelessWidget{
  final String documentId;
  GetInfo({required this.documentId});

  var nUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;

  @override
  Widget build(BuildContext context){
    CollectionReference users = FirebaseFirestore.instance.collection('UserAccounts').doc(myUid).collection('UserInfo');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot){

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data=
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('Full name: \n${data['Full name']}' + '\n\n' + 'Age: ${data['Age']}' + '\n\n' + 'Address: ${data['Address']}',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            decorationColor: Colors.black
          ),
          );
        }
        return Text('Loading...');

    }),
    );

  }

}