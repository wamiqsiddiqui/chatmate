import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { received, sent, delivered, seen }

class Message {
  final String id;
  final String text;
  final String type;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String status;
  Message(
      {required this.id,
      required this.text,
      required this.type,
      required this.senderId,
      required this.receiverId,
      required this.status,
      required this.timestamp});

  factory Message.fromMap(data) => Message(
      id: data['id'],
      text: data['text'],
      type: data['type'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      status: data['status'],
      timestamp: data['timestamp']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'type': type,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': timestamp,
        'status': status
      };

  @override
  toString() => '$text $status';
}
