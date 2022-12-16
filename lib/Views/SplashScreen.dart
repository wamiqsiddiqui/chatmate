import 'dart:async';

import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/ChatRoom.dart';
import 'package:chatmate/Views/SignIn.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) { 
                  if(FirebaseServices.getCurrentUser()!=null){
                    print('already logged in');
                    return ChatRoom();
                  }else{
                    print('not logged in already');
                    return SignIn();
                  }
                  }
                  )));
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xff06344c),
        ),
        child: Center(
          child: Text(
            "!  C  H  A  T    M  A  T  E  !",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
