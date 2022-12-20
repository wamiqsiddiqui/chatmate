import 'package:chatmate/Views/ChatRoom.dart';
import 'package:chatmate/Views/Search.dart';
import 'package:chatmate/Views/home.dart';
import 'package:chatmate/router/arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String routeName = settings.name!;
    switch (routeName) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/search':
        return MaterialPageRoute(
            builder: (_) => Search(
                  searchResult: [],
                ));
      case '/chatroom':
        ChatRoomArguments arguments = settings.arguments as ChatRoomArguments;
        return MaterialPageRoute(
            builder: (_) => ChatRoom(receiver: arguments.receiver));
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
