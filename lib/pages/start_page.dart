import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:storiq/pages/home.dart';
import '../network.dart';
import 'sign_up_page.dart';
import '../sign_in_with/sign_in_with_facebook_button.dart';
import '../sign_in_with/sign_in_with_google_button.dart';

class SocialMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  Function(String) onSuccessfulLogin(BuildContext context) => (String uid) {
    log("uid: $uid", name: "onSuccessfulLogin");
    user = uid;
    if(uid == null)
      return;
    userExists().then((exists) {
      if(exists){
        getMainUserProfile().then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      }
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      }
    });
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              "StoriQ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SignInWithGoogleButton(
                  onSuccess: onSuccessfulLogin(context),
                ),
              ),
              Center(
                child: SignInWithFacebookButton(
                  onSuccess: onSuccessfulLogin(context),
                ),
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ],
      ),
    );
  }
}
