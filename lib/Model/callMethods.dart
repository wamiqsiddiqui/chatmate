import 'dart:html';

import 'package:chatmate/Model/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream(String uid) =>
      callCollection.doc(uid).snapshots();

  Future makeCall(Call call) async {
    try {
      call.hasDialed = true;
      Map<String, dynamic> hasDialedMap = call.toMap();
      call.hasDialed = false;
      Map<String, dynamic> hasReceiverMap = call.toMap();

      await callCollection.doc(call.callerId).set(hasDialedMap);
      await callCollection.doc(call.receiverId).set(hasReceiverMap);
    } catch (e) {
      print('Error in making call = $e');
    }
  }

  Future<bool> endCall(Call call) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print('Error in deleting call = $e');
      return false;
    }
  }
}
