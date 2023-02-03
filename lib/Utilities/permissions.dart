import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/services.dart';

class PermissionsHelper {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission.isDenied || !permission.isGranted) {
      Permission permission = Permission.camera;
      final PermissionStatus status = await permission.request();
      return status;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> requestPermisison(
      Permission permission) async {
    try {
      final PermissionStatus status = await permission.request();
      return status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  static Future<bool> isPermissionGranted(Permission permission) async {
    return permission.isGranted;
  }

  static Future checkGps(context) async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Column(
                  children: [
                    Text('Please enable  GPS and try again!'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: () => onConfirm(context),
                        child: Text('Okay'))
                  ],
                ));
      }
    }
  }

  static onConfirm(context) {
    AndroidIntent intent =
        AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTONGS');
    intent.launch();
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (permission.isDenied || !permission.isGranted) {
      Permission permission = Permission.microphone;
      final PermissionStatus status = await permission.request();
      return status;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }
}
