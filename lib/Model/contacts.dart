import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String uid;
  final Timestamp addedOn;
  Contact({required this.uid, required this.addedOn});
  factory Contact.fromMap(map) =>
      Contact(uid: map['uid'], addedOn: map['addedOn']);
  static Map<String, dynamic> toMap(Contact contact) =>
      {'uid': contact.uid, 'addedOn': contact.addedOn};
}
