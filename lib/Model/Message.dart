import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String type;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  Message(
      {required this.id,
      required this.text,
      required this.type,
      required this.senderId,
      required this.receiverId,
      required this.timestamp});

  factory Message.fromMap(Map<String, dynamic> data) => Message(
      id: data['id'],
      text: data['text'],
      type: data['type'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      timestamp: data['timestamp']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'type': type,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': timestamp
      };
}
