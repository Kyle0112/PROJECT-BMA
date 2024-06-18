import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/login_screen.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key, required String title}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('BMA'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15), //apply padding to all four sides
              child: Text(
                "Enter email to get password reset link",
                style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Enter email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailController.text)
                      .then((value) async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Account Reset'),
                              content: Text(
                                  'Reset link sent! please check your spam folder if not received'),
                              actions: [
                                TextButton(
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                          title: '/login',
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ));
                  });
                },
              ),
            ),
          ],
        ));
  }
}
