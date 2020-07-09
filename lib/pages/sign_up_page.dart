import 'dart:ui';

import 'package:flutter/material.dart';
import '../network.dart';
import 'package:storiq/pages/home.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name, address;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            constraints: BoxConstraints(
              maxWidth: 500,
            ),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Name",
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                  onSubmitted: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Address",
                  ),
                  onChanged: (value) {
                    address = value;
                  },
                  onSubmitted: (value) {
                    address = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    createProfile(name, address);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
