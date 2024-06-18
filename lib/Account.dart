
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Menu_Screen.dart';
import 'package:untitled/widget/button.dart';



class EditProfileUI extends StatefulWidget {
   const EditProfileUI({Key? key, required String title}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _EditProfileUIState();

}

class _EditProfileUIState extends State<EditProfileUI> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();


  var nUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
              Image(image: AssetImage('assets/icon.png'),
              height: 200,
              width: 200,),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                          controller: _nameController,
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return 'Please enter text';
                            }
                            else null;
                          },
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person,color: Colors.blue,),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors. blue),
                          ),
                          labelStyle: TextStyle(color: Colors.blue, fontSize: 15)
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return 'Please enter text';
                            }
                            else null;
                          },
                        decoration: const InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on,color: Colors.blue,),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors. blue),
                            ),
                            labelStyle: TextStyle(color: Colors.blue, fontSize: 15)
                        ),

                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _ageController,
                        validator: (value){
                          if (value == null || value.isEmpty){
                            return 'Please enter text';
                          }
                          else null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Age',
                            prefixIcon: Icon(Icons.numbers_sharp,color: Colors.blue,),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors. blue),
                            ),
                            labelStyle: TextStyle(color: Colors.blue, fontSize: 15)
                        ),
                            keyboardType: TextInputType.number
                      ),
                    ],

              )),
            SizedBox(height: 30),
            myButton(
              onPress: (){
                nUser = FirebaseFirestore.instance.collection('UserAccounts').doc(myUid).collection('UserInfo');
                nUser
                    .doc(myUid)
                    .update(
                    {
                  'Age': _ageController.text,
                  'Full name' : _nameController.text,
                  'Address' : _addressController.text
                    });
                if(_formKey.currentState!.validate()){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MenuScreen();
                  }));
                }

              }

            )
          ]
        )
      )
    );
  }


}
