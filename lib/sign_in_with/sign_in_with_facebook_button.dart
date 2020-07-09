import 'package:flutter/material.dart';
import 'package:storiq/sign_in_with/sign_in_with_facebook.dart';

class SignInWithFacebookButton extends StatelessWidget {

  final Function(String uid) onSuccess;

  SignInWithFacebookButton({this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          "LOG IN FACEBOOK",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        signInWithFacebook(context).then(onSuccess);
      },
    );
  }
}