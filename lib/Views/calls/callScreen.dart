import 'dart:async';

import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  const CallScreen({Key? key, required this.call}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  CallMethods callMethods = CallMethods();
  late StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callStreamSubscription = callMethods
          .callStream(FirebaseServices.currentUser!.uid)
          .listen((DocumentSnapshot documentSnapshot) {
        switch (documentSnapshot.data()) {
          case null:
            Navigator.pop(context);
            break;
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    callStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Call has been made',
              style: Theme.of(context).textTheme.headline1,
            ),
            FloatingActionButton(
              backgroundColor: AppColors.errorColor,
              child: Icon(Icons.call_end),
              onPressed: () {
                callMethods.endCall(widget.call);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
