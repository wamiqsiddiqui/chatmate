import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/calls/pickupCalls/pickupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffoldChild;
  final CallMethods callMethods = CallMethods();
  PickupLayout({Key? key, required this.scaffoldChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseServices.currentUser != null
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(FirebaseServices.currentUser!.uid),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                Call call = Call.fromMap(snapshot.data!);
                print('Pickup Layout.dart');
                print(
                    'FirebaseServices.currentUser!.uid - ${FirebaseServices.currentUser!.uid}');
                print('call.hasDialed = ${call.hasDialed}');
                print('callerName = ${call.callerName}');
                print('receiverName = ${call.receiverName}');
                print('hasDialed = ${call.hasDialed}');
                print('channelId = ${call.channelId}');
                if (!call.hasDialed) {
                  return PickupScreen(call: call);
                } else {
                  return scaffoldChild;
                }
              }
              return scaffoldChild;
            },
          )
        : CircularProgressIndicator();
  }
}
