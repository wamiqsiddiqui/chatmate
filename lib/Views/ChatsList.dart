import 'package:chatmate/Model/contacts.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/quietBox.dart';
import 'package:chatmate/Widgets/ChatTile.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: ThemeColors.white,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(32), topRight: Radius.circular(32))
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseServices.fetchContacts(
              userId: FirebaseServices.currentUser!.uid),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              print('snapshot contacts data = ${snapshot.data}');
              List<QueryDocumentSnapshot> docList = snapshot.data!.docs;
              if (docList.isEmpty) {
                return QuietBox();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListView.separated(
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    print('docList[index].data = ${docList[index].data()}');
                    Contact contact = Contact.fromMap(docList[index].data());
                    return ChatTile(
                      contact: contact,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              );
            }
            // Put Shimmer later
            return CircularProgressIndicator();
          }),
    );
  }
}
