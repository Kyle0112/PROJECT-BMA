import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:untitled/utils/apikey.dart';
import 'package:http/http.dart' as http;


class ocrScan extends StatefulWidget {
  ocrScan({super.key, required String title});

  @override
  State<ocrScan> createState() => _ocrScanState();
}

class _ocrScanState extends State<ocrScan> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;
  var uniqueid;
  var users;


  late File pickedimage;
  bool scanning = false;
  String scannedText = '';
  String dateExtractText = '';
  String totalExtractText = '';

  RegExp dateRegEx = RegExp(
      r'\d+[/.-]\d+[/.-]\d+');
  RegExp totalRegEx = RegExp(
      r'\d[,\d]+\.\d+');

  TextEditingController _dateController = TextEditingController();
  TextEditingController _totalController = TextEditingController();


  optionsdialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: ()=>pickimage(ImageSource.gallery),
              child: Text("Gallery",)
            ),
            SimpleDialogOption(
                onPressed: ()=>pickimage(ImageSource.camera),
                child: Text("Camera",)
            ),
            SimpleDialogOption(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Cancel",)
            ),
          ],
        );
      },
    );
  }

  pickimage(ImageSource source)async{
  final image = await ImagePicker().getImage(source: source);
  setState(() {
    scanning = true;
    pickedimage = File(image!.path);
  });
  Navigator.pop(context);
  Uint8List bytes = Io.File(pickedimage.path).readAsBytesSync();
  String img64 = base64Encode(bytes);
  String url = 'https://api.ocr.space/parse/image';
  var data = {"base64Image": "data:image/jpg;base64,$img64"};
  var header = {"apikey": apikey};
  http.Response response = await http.post(Uri.parse(url),
      body: data,
      headers: header,
  );




  Map result = jsonDecode(response.body);
  (result['ParsedResults'][0]['ParsedText']);
  setState(() {
    scanning = false;
    scannedText = result['ParsedResults'][0]['ParsedText'];

    dateExtractText = dateRegEx.stringMatch(scannedText)!;
    _dateController.text = dateExtractText;

    totalExtractText = totalRegEx.stringMatch(scannedText)!;
    _totalController.text = totalExtractText;
  });

  setState(() {
    scanning = false;
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
      ),
      appBar: AppBar(
        title: const Text('Receipt scanner'),
        backgroundColor: Colors.purple[400],
      ),
        body: ListView(
          children: <Widget> [
            InkWell(
              onTap: ()=>optionsdialog(context),
              child: Image(
                image: AssetImage('assets/camera.png'),

              ),
            ),

            scanning == true ? CircularProgressIndicator() :
            TextFormField(controller: _dateController,
            decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
              borderRadius: BorderRadius.circular(5.5),
            ),
            prefixIcon: Icon(Icons.receipt_long,
                color: Colors.purple[400]),
            labelText: "Date of Receipt",
            labelStyle: TextStyle(color: Colors.purple[400])
            )
            )
            ,
            SizedBox(height: 20),
            scanning == true ? CircularProgressIndicator() :
            TextFormField(controller: _totalController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    prefixIcon: Icon(Icons.attach_money,
                    color: Colors.purple[400]),
                    labelText: "Total",
                    labelStyle: TextStyle(color: Colors.purple[400],
                    )
                )
            ),
                SizedBox(height: 40),
                ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                    MaterialStateProperty.all(Colors.purple[400])),
                     child: const Text(
                      "Submit",
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => {
                          showActionSnackBar(context),
                          users = FirebaseFirestore.instance
                          .collection('UserAccounts')
                          .doc(myUid)
                          .collection('userTrans')
                          .add(
                          {
                            'Total amount': _totalController.text,
                            'Date of Receipt': _dateController.text
                          },
                         ),
                        users = FirebaseFirestore.instance
                            .collection('UserAccounts')
                            .doc(myUid)
                            .collection('dataInference')
                            .add(
                          {
                            'Total amount': _totalController.text,
                            'Date of Receipt': DateTime.now()
                          },
                        )
                        }
                )
          ],

        )
    );
  }
  void showActionSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Form is submitted successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}