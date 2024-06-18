

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/Account.dart';
import 'package:untitled/get_info.dart';



class AccountInfo extends StatelessWidget{

  var nUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;


  List<String> docIDs = [];
  Future getDocId() async{
    await FirebaseFirestore.instance.collection('UserAccounts').doc(myUid).collection('UserInfo').get().then(
        (snapshot) => snapshot.docs.forEach((element) {
          print(element.reference);
          docIDs.add(element.reference.id);
        })
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      title: Text('Account Information'),
        actions:[
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfileUI(title: 'accnt',),),);
          },icon:Icon(Icons.settings))
        ],
      ),

    body:
    FutureBuilder(
      future: getDocId(),
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: docIDs.length,
          itemBuilder: (context, index){
            return Padding(

              padding: const EdgeInsets.all(20),
              child: ListTile(

                title: GetInfo(documentId: docIDs[index]),
              ),

            );
          }
        );
      }
    )
    );
  }

  }
