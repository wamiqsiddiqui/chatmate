import 'package:chatmate/Model/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  const LastMessageContainer({Key? key, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data!.docs;
            if (docList.isNotEmpty) {
              Message message = Message.fromMap(docList.last);
              return Text(
                message.text,
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            }
            return Text('No Message',
                style: Theme.of(context).textTheme.bodyText1);
          }
          return Text('..', style: Theme.of(context).textTheme.bodyText1);
        });
  }
}
