import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Menu_Screen.dart';
import 'package:untitled/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required String title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passconfController = TextEditingController();


  var nUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;




bool passconfirmed(){
  if(_passconfController.text == _passController.text ){
    return true;
  } else{
    return false;
  };
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.all(24),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _header(context),
          _inputFields(context),
          _loginInfo(context),
        ]),
      ),
    ));
  }

  _header(context) {
    return Column(
      children: [
        Text(
          "Create Account",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter details to get started"),
      ],
    );
  }



  _inputFields(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Full Name",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: "Address",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            hintText: "Age",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.numbers),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email Address",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _passController,
          decoration: InputDecoration(
            hintText: "Password",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.password_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _passconfController,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.password_outlined),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              if(passconfirmed()) {
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passController.text)
                    .then((value) async {
                  await showDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: Text('Account Creation'),
                        content: Text('Registered successfully'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {

                                nUser = FirebaseFirestore.instance.collection('UserAccounts').doc(myUid).collection('UserInfo').doc(myUid).set(
                                    {
                                      'Full name' : _nameController.text,
                                      'Age' : _ageController.text,
                                      'Email': _emailController.text,
                                      'Address' : _addressController.text
                                    }
                                );
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MenuScreen(),),);

                            },)
                        ],
                      ));

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(
                            title: '/login',
                          ),
                    ),
                  );
                }).onError((error, stackTrace) async {
                  showDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: Text('Registration Error'),
                        content: Text(error.toString()
                            .replaceRange(0, 14, '')
                            .split(']')[1]),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },)
                        ],
                      ));
                });




              } else{
                {
                  showDialog(context: context, builder: (context) =>
                    AlertDialog(
                      title: Text('Registration Error'),
                      content: Text('Password confirmation wrong'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },)
                      ],
                    ));
              }
              };

            } on FirebaseAuthException catch (e) {
              print(e.code);
            } catch(e){
              print(e);
            }

          },


          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        )
      ],
    );
  }

  _loginInfo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?"),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    title: '/login',
                  ),
                ),
              );
            },
            child: Text("Login"))
      ],
    );
  }

}
