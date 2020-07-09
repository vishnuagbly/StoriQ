import 'dart:developer';

import 'package:flutter/material.dart';
import 'sign_in_with_google.dart';

class SignInWithGoogleButton extends StatelessWidget {
  SignInWithGoogleButton({
    this.onSuccess,
    this.duringProcess = duringProcessDefault,
  });

  final Function(String userId) onSuccess;
  final Function() duringProcess;

  static void duringProcessDefault() {}

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          "LOG IN GOOGLE",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        duringProcess();
        signInWithGoogle().then(onSuccess).catchError((onError) {
          log(onError, name: "signInWithGoogleButton");
        });
      },
    );
  }
}
