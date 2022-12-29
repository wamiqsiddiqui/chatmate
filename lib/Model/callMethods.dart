import 'package:chatmate/Model/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream(String uid) {
    print('#################uid - ${uid}');
    return callCollection.doc(uid).snapshots();
  }

  Future<Call?> makeCall(Call call) async {
    try {
      call.hasDialed = false;
      Map<String, dynamic> hasReceiverMap = call.toMap();
      call.hasDialed = true;
      Map<String, dynamic> hasDialedMap = call.toMap();

      await callCollection.doc(call.callerId).set(hasDialedMap);
      await callCollection.doc(call.receiverId).set(hasReceiverMap);
      return call;
    } catch (e) {
      print('Error in making call = $e');
      return null;
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
