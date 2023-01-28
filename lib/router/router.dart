import 'package:chatmate/Views/ChatRoom.dart';
import 'package:chatmate/Views/Search.dart';
import 'package:chatmate/Views/calls/callScreen.dart';
import 'package:chatmate/Views/home.dart';
import 'package:chatmate/router/arguments.dart';
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
      case '/callScreen':
        CallScreenArguments arguments =
            settings.arguments as CallScreenArguments;
        print(
            '!!!!!!!!!!!!!!!!!!!!!!!!!!!!arguments.call  = ${arguments.call.hasDialed}');
        return MaterialPageRoute(
            builder: (_) => CallScreen(call: arguments.call));
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
