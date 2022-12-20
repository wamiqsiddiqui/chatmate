import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class ChatRoom extends StatefulWidget {
  CAUser receiver;
  ChatRoom({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController sendTextCtrl = TextEditingController();
  ScrollController chatScrollCtrl = ScrollController();
  List<bool> chats = [true, false, true, false, false, false, true];
  Widget receiverChat() {
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 16, left: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
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
            'Hello World Wamiqq Hello World Wamiqq Hello World Wamiqq Hello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World Wamiqq',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget senderChat() {
    return UnconstrainedBox(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 16, right: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
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
            'Hello World Wamiqq Hello World Wamiqq Hello World Wamiqq Hello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World WamiqqHello World Wamiqq',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  sendMessage(String text) async {
    await FirebaseServices.sendMessage(text, widget.receiver.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (chatScrollCtrl.hasClients) {
      print('what');
      chatScrollCtrl.jumpTo(chatScrollCtrl.position.maxScrollExtent);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            UserCircle(),
            SizedBox(width: 8),
            Text('Brooo'),
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
              onPressed: () {
                Navigator.pop(context);
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
          Flexible(
              child: ListView.builder(
                  itemCount: 7,
                  controller: chatScrollCtrl,
                  reverse: false,
                  itemBuilder: (context, index) {
                    if (chatScrollCtrl.hasClients) {
                      print('what');
                      SchedulerBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        chatScrollCtrl.animateTo(
                            chatScrollCtrl.position.maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      });
                    }
                    return chats[index] ? receiverChat() : senderChat();
                  })),
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
