import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/Utilities/permissions.dart';
import 'package:chatmate/router/arguments.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  PickupScreen({Key? key, required this.call}) : super(key: key);

  final CallMethods callMethods = CallMethods();

  pickupCall(context) {
    CallScreenArguments arguments =
        CallScreenArguments(call: call, hasDialed: true);
    Navigator.pushNamed(context, '/callScreen', arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming...'),
            SizedBox(height: 48),
            Image.network(call.callerPic, height: 152, width: 152),
            SizedBox(height: 16),
            Text(call.callerName, style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 72),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: AppColors.errorColor,
                  onPressed: () async {
                    await callMethods.endCall(call);
                  },
                ),
                SizedBox(width: 24),
                IconButton(
                  icon: Icon(Icons.call),
                  color: AppColors.successGreenColor,
                  onPressed: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? pickupCall(context)
                        : {};
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
