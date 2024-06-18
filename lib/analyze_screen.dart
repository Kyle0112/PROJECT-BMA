import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/InputOpt.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/expnse.dart';

class PredModel extends StatefulWidget {
  const PredModel({Key? key, required String title}) : super(key: key);
  @override
  _PredModelState createState() => _PredModelState();
}

var nUser;
final FirebaseAuth auth = FirebaseAuth.instance;
late final User? user = auth.currentUser;
late final myUid = user!.uid;
final _theBox = Hive.box('dataInference');

class _PredModelState extends State<PredModel> {
  var predValue = "";

  @override
  void initState() {
    super.initState();

    predValue = "click predict button";
  }

  List<dynamic> mlinpt = [];

  var inference;
  final CollectionReference mlPut = FirebaseFirestore.instance
      .collection('UserAccounts')
      .doc(myUid)
      .collection('dataInference');

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('UserAccounts')
        .doc(myUid)
        .collection('dataInference')
        .limit(5)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              mlinpt.add(element.reference.id);
            }));
  }

  Future<void> predData() async {
    final interpreter = await Interpreter.fromAsset('model/kerasregopt.tflite');
    var input = [inference];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);
    this.setState(() {
      predValue = output[0][0].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body:
      FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: mlinpt.length,
                itemBuilder: (context, index) {
                  inference = GetInfo(documentId: mlinpt[index]);
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListTile(
                      title: GetInfo(documentId: mlinpt[index]),
                    ),
                  );
                });
          }),
    );
  }
}
