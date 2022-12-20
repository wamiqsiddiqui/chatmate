import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Widgets/ChatTile.dart';
import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/router/arguments.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  List<CAUser> searchResult;
  Search({required this.searchResult});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    print('widget.searchResult = ${widget.searchResult.length}');
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: ThemeColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView.separated(
          itemCount: widget.searchResult.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              ChatRoomArguments arguments =
                  ChatRoomArguments(receiver: widget.searchResult[index]);
              Navigator.pushNamed(context, '/chatroom', arguments: arguments);
            },
            child: Container(
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
                                widget.searchResult[index].name,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                '',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          Text(
                            widget.searchResult[index].email,
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
            ),
          ),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
