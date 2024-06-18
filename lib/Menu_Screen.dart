import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/Account.dart';
import 'package:untitled/AccountInfo.dart';
import 'package:untitled/InputOpt.dart';
import 'package:untitled/analyze_screen.dart';
import 'package:untitled/get_userData.dart';
import 'package:untitled/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Display_data.dart';
import 'package:untitled/ocrScan.dart';
import 'package:hive_flutter/hive_flutter.dart';



class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {



  @override

  Widget build(BuildContext context) {
    var cUser;
    final FirebaseAuth auth = FirebaseAuth.instance;
    late final User? user = auth.currentUser;
    late final myUid = user!.uid;
    var size = MediaQuery.of(context).size; // for size


    User? name = FirebaseAuth.instance.currentUser;

    final _theBox = Hive.box('dataInference');
  void delete(){
    _theBox.delete(0);
  }

    var bttnstyle = TextStyle(
        fontFamily: 'Poppins', fontSize: 14, color: Colors.blue); //button fonts
    return Builder(builder: (context) {


      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: size.height * .3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image:
                          AssetImage('assets/BmaImages/HeaderMenuBlue.png'))),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 64,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: AssetImage(
                                'assets/BmaImages/iconsprof.png'),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'User:${user!.email!}'.trim(),
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: Colors.black),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    //cards
                    Expanded(
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        crossAxisCount: 2,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AccountInfo(),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/profileuser.svg",
                                    height: 128,
                                  ),
                                  Text(
                                    'Account',
                                    style: bttnstyle,
                                  )
                                ],
                              ),
                            ),
                          ), //account
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                    "assets/icons/statsforreport.svg",
                                    height: 128),
                                Text(
                                  'Report',
                                  style: bttnstyle,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InputOpt(
                                    title: 'InOpt',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/tapimport.svg",
                                    height: 128,
                                  ),
                                  Text(
                                    'Import',
                                    style: bttnstyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PredModel(
                                    title: 'pModel',
                                  ),
                                ),
                              );
                            },
                          child :Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/abacusforanalyze.svg",
                                  height: 128,
                                ),
                                Text(
                                  'Analyze',
                                  style: bttnstyle,
                                )
                              ],
                            ),
                          ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ocrScan(title: 'ocr'),
                                  ),
                                );
                              },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/oddscanner.svg",
                                  height: 128,
                                ),
                                Text(
                                  'Scan',
                                  style: bttnstyle,
                                )
                              ],
                            ),
                          ),
                          ),
                          InkWell(
                            onTap: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                      title: '/login',
                                    ),
                                  ),
                                );
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/exitsign.svg",
                                    height: 128,
                                  ),
                                  Text(
                                    'Logout',
                                    style: bttnstyle,
                                  )
                                ],
                              ),
                            ),
                          ), //test nav
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
