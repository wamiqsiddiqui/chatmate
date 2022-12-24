import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/themes/AppColors.dart';
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
      margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: ThemeColors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 0.4, offset: Offset(1, 2), color: AppColors.bgGrey)
          ],
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ThemeColors.receiverColor,
              ThemeColors.receiverColor.withOpacity(0.2),
            ],
          )
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
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: ThemeColors.primaryColor,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(82))),
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
                        'Wamiq',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        'Yesterday',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Text(
                    'Long text',
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
