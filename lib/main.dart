import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/Account.dart';
import 'package:untitled/Menu_Screen.dart';
import 'package:untitled/InputOpt.dart';
import 'package:untitled/forgot_page.dart';
import 'package:untitled/login_screen.dart';
import 'package:untitled/analyze_screen.dart';
import 'package:untitled/AccountInfo.dart';
import 'package:untitled/ocrScan.dart';
import 'package:untitled/get_info.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();

  var box = await Hive.openBox('dataInference');

  runApp(Bma());
}




class Bma extends StatelessWidget{
  @override
  Widget build(BuildContext) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
       initialRoute: '/lc',
       routes: <String, WidgetBuilder>{
           '/': (context) => MenuScreen(),
           '/lc': (context) => LoginScreen(title: 'login',),
           '/': (context) => AccountInfo(),
           '/io': (context) => InputOpt(title: 'InOpt',),
           '/fp': (context) => ForgotPass(title: 'forgot'),
           '/pm': (context) => PredModel(title: 'pModel'),
           '/ocr':(context) => ocrScan(title: 'ocr')


       }


   );
  }
}
