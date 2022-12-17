import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({Key? key}) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 4, top: 8, bottom: 8),
      child: Row(
        children: [
          Flexible(
            child: UserCircle(),
          ),
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
                        'Brooo',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        'Yesterday',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Text(
                    'Ajeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebbb Wamiqqqqq kyaa maslaa haaaiii dimaghh kharabbbb !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
