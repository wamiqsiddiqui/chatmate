import 'package:chatmate/Widgets/ChatTile.dart';
import 'package:chatmate/themes/AppColors.dart';
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView.separated(
          itemCount: 16,
          itemBuilder: (context, index) => ChatTile(),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
