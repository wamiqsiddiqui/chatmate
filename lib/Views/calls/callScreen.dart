import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  const CallScreen({Key? key, required this.call}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  CallMethods callMethods = CallMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Call has been made',
              style: Theme.of(context).textTheme.headline1,
            ),
            FloatingActionButton(
              backgroundColor: AppColors.errorColor,
              child: Icon(Icons.call_end),
              onPressed: () {
                callMethods.endCall(widget.call);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
