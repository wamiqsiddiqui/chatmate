import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Utilities/permissions.dart';
import 'package:chatmate/notificationService/localNotificationService.dart';
import 'package:chatmate/Utilities/callHelper.dart';
import 'package:chatmate/router/arguments.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  CAUser receiver;
  ChatRoom({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      print('FirebaseMEssaging.onMessage.listen');
      if (message.notification != null) {
        print('message.notification!.title = ${message.notification!.title}');
        print('message.notification!.body = ${message.notification!.body}');
        print('message.data = ${message.data}');
        LocalNotificationService.createAndDisplayNotificationChannel(message);
      }
    });
  }

  TextEditingController sendTextCtrl = TextEditingController();
  ScrollController chatScrollCtrl = ScrollController();
  List<bool> chats = [true, false, true, false, false, false, true];
  String errorMessage = '';
  Widget receiverChat(DocumentSnapshot snapshot) {
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 4, left: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65),
            decoration: BoxDecoration(
                color: ThemeColors.receiverColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                snapshot['text'],
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                DateFormat('hh:mm a')
                    .format(snapshot['timestamp'].toDate())
                    .toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget senderChat(DocumentSnapshot snapshot, bool hasPendingWrites) {
    return UnconstrainedBox(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 4, right: 12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65),
            decoration: BoxDecoration(
                color: ThemeColors.senderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                snapshot['text'] + 'hasPendingWrites = $hasPendingWrites',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                DateFormat('hh:mm a')
                    .format(snapshot['timestamp'].toDate())
                    .toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sendMessage(String text) async {
    await FirebaseServices.sendMessage(
        text, widget.receiver.uid, widget.receiver.name);
    LocalNotificationService.sendMessageNotification(
        'New Message from ${FirebaseServices.currentUser!.displayName!}',
        text,
        widget.receiver.fcmToken,
        FirebaseServices.currentUser!.photoURL!);
  }

  dial() async {
    debugPrint('dial = ${FirebaseServices.currentUser!.uid}');
    Call call = await CallHelper.dial(
        FirebaseServices.currentUser!, widget.receiver, context);
    print('dial in Chatroom.dart');
    print('call.hasDialed = ${call.hasDialed}');
    print('callerName = ${call.callerName}');
    print('receiverName = ${call.receiverName}');
    print('hasDialed = ${call.hasDialed}');
    print('channelId = ${call.channelId}');
    CallScreenArguments arguments =
        CallScreenArguments(call: call, hasDialed: true);
    Navigator.pushNamed(context, '/callScreen', arguments: arguments);
    errorMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          children: [
            // UserCircle(),
            SizedBox(width: 8),
            Text(widget.receiver.name),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.video_call_rounded),
              onPressed: () async {
                try {
                  // await Permissions.cameraAndMicrophonePermissionsGranted()
                  dial();
                  // : {};
                } catch (e) {
                  errorMessage = 'Something went wrong please try again!';
                  print('Error while getting call object = $e');
                }
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseServices.receiveMessage(
                  widget.receiver.uid, widget.receiver.name),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                print('rebuild ${snapshot.data!.metadata.hasPendingWrites}');
                if (snapshot.data == null) {
                  return Text('Getting messages');
                }
                return Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        controller: chatScrollCtrl,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return snapshot.data!.docs[index]['senderId'] ==
                                  FirebaseServices.currentUser!.uid
                              ? senderChat(snapshot.data!.docs[index],
                                  snapshot.data!.metadata.hasPendingWrites)
                              : receiverChat(snapshot.data!.docs[index]);
                        }));
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sendTextCtrl,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        labelText: 'Type your message',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.attachment), Icon(Icons.face)],
                        ),
                        prefixIcon: Icon(Icons.camera_alt)),
                  ),
                ),
                FloatingActionButton(
                    child: Icon(Icons.send_rounded),
                    onPressed: () async {
                      await sendMessage(sendTextCtrl.text);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
