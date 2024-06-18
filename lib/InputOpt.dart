import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputOpt extends StatefulWidget {
  const InputOpt({Key? key, required String title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputOpt();
}

class _InputOpt extends State<InputOpt> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  late final User? user = auth.currentUser;
  late final myUid = user!.uid;

  _InputOpt() {
    _selectedVal = _storeTypeList[0];
  }

  var uniqueid;
  var users;
  final TextEditingController _date = TextEditingController();
  final _storeTypeList = [
    "Grocery",
    "Transportation",
    "Food and beverages",
    "Luxury",
    "etc"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedVal = "";
  String? storeName;
  double? totalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Details'),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
            child: Text(
              "Receipt",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 79, vertical: 0),
            child: Text(
              "Input receipt details in the form below",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: DropdownButtonFormField(
              value: _selectedVal,
              items: _storeTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedVal = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.red,
              ),
              dropdownColor: Colors.red[200],
              decoration: const InputDecoration(
                labelText: "Store Type",
                labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontFamily: 'Quicksand'),
                prefixIcon: Icon(
                  Icons.local_grocery_store,
                  color: Colors.red,
                ),
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                onChanged: (value) {
                  storeName = value;
                },
                decoration: const InputDecoration(
                  labelText: "Store name",
                  labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: 'Quicksand'),
                  border: UnderlineInputBorder(),
                  icon: Icon(Icons.storefront_outlined, color: Colors.red),
                ),
                keyboardType: TextInputType.text,
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                onChanged: (val) {
                  totalAmount = double.tryParse(val);
                },
                decoration: const InputDecoration(
                    labelText: "Total amount",
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Quicksand'),
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.monetization_on, color: Colors.red)),
                keyboardType: TextInputType.number,
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                  controller: _date,
                  decoration: const InputDecoration(
                      labelText: "Date of Receipt",
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'Quicksand'),
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.receipt_long, color: Colors.red)),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2023));

                    if (pickeddate != null) {
                      setState(() {
                        _date.text = DateFormat.yMEd().format(pickeddate);
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[400])),
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
                            'Store type': _selectedVal,
                            'Store name': storeName,
                            'Total amount': totalAmount,
                            'Date of Receipt': _date.text
                          },
                        )
                        })
                      ),
        ],
      ),
    );
  }

  void showActionSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Form is submitted successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
