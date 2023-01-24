import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Model/contacts.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/Widgets/lastMessageContainer.dart';
import 'package:chatmate/router/arguments.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final Contact contact;
  const ChatTile({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CAUser?>(
      future: FirebaseServices.getUserDetailsById(contact.uid),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          CAUser? user = snapshot.data;
          return ViewLayout(contactUser: user!);
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class ViewLayout extends StatelessWidget {
  final CAUser contactUser;
  const ViewLayout({Key? key, required this.contactUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ChatRoomArguments arguments = ChatRoomArguments(receiver: contactUser);
        Navigator.pushNamed(context, '/chatroom', arguments: arguments);
      },
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          // boxShadow: [
          //   BoxShadow(
          //       blurRadius: 0.4, offset: Offset(1, 2), color: AppColors.bgGrey)
          // ],
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.topCenter,
          //   colors: [
          //     ThemeColors.gradient1.withOpacity(0.3),
          //     // ThemeColors.gradient2,
          //     ThemeColors.gradient1,
          //   ],
          // )
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(32),
          //   bottomRight: Radius.circular(32),
          //   // topLeft: Radius.circular(12),
          //   // topRight: Radius.circular(12),
          // )
        ),
        child: Row(
          children: [
            Flexible(
              child: UserCircle(),
            ),
            // Container(
            //   height: 32,
            //   width: 32,
            //   decoration: BoxDecoration(
            //       color: ThemeColors.primaryColor,
            //       borderRadius:
            //           BorderRadius.only(bottomLeft: Radius.circular(82))),
            // ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          contactUser.name.split(' ')[1],
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          'Yesterday',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    LastMessageContainer(
                        stream: FirebaseServices.fetchLastMessageBetween(
                            senderId: FirebaseServices.currentUser!.uid,
                            receiverName: contactUser.name,
                            receiverId: contactUser.uid)),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
