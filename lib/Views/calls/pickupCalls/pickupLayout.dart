import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/calls/pickupCalls/pickupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  PickupLayout({Key? key, required this.scaffold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return FirebaseServices.currentUser != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: callMethods.callStream(FirebaseServices.currentUser!.uid),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                print('snapshot.data!.exists = ${snapshot.data!.exists}');
                if (snapshot.hasData && snapshot.data!.exists) {
                  Call call = Call.fromMap(snapshot.data!);
                  if (!call.hasDialed) {
                    return PickupScreen(call: call);
                  } else {
                    return scaffold;
                  }
                }
                return scaffold;
              },
            )
          : CircularProgressIndicator();
    } catch (e) {
      return CircularProgressIndicator();
    }
  }
}
