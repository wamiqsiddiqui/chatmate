import 'dart:math';

import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallHelper {
  static final CallMethods callMethods = CallMethods();

  static Future<Call> dial(User caUserFrom, CAUser caUserTo, context) async {
    try {
      Call call = Call(
          callerId: caUserFrom.uid,
          callerName: caUserFrom.displayName!,
          callerPic: caUserFrom.photoURL!,
          receiverId: caUserTo.uid,
          receiverName: caUserTo.name,
          receiverPic: caUserTo.profilePhoto!,
          channelId:
              caUserFrom.uid + caUserTo.uid + Random().nextInt(1000).toString(),
          hasDialed: true);
      await callMethods.makeCall(call);
      return call;
    } catch (e) {
      print('Error while dialing = $e');
      rethrow;
    }
  }
}
