import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Model/call.dart';

class ChatRoomArguments {
  CAUser receiver;
  ChatRoomArguments({required this.receiver});
}

class CallScreenArguments {
  Call call;
  bool hasDialed;
  CallScreenArguments({required this.call, this.hasDialed = false});
}
