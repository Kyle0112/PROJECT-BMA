import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/signup.dart';
import 'package:untitled/Menu_Screen.dart';
import 'package:untitled/forgot_page.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required String title}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailsigninController = TextEditingController();
  final TextEditingController _passloginController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
          Container(),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "B.M.A",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _emailsigninController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Enter email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _passloginController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Column(
                        children: [
                          TextButton(onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPass(title: 'forgot',);
                                }
                              ),
                            );

                          }, child: const Text(
                              "Forget Password?"
                          )),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.green]),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                          FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailsigninController.text,
                              password: _passloginController.text).then((value)
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MenuScreen(),),);
                              }
                          ).onError((error, stackTrace) {
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: Text('Login Error'),
                              content: Text('Invalid Email or Password'),
                              actions: [
                                TextButton(
                                child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },)
                              ],
                            ));
                          });
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  const Divider(
                    height: 30,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                        ),

                      ),
                      TextButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen(title: '/sign',),),);
                      }, child: const Text(
                          "Sign Up"
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
          )
            ],
          ),
        );
      }
    );
  }
}
