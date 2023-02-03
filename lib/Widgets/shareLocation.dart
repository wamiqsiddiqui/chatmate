import 'package:chatmate/Utilities/permissions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareLocation extends StatefulWidget {
  const ShareLocation({Key? key}) : super(key: key);

  @override
  State<ShareLocation> createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  @override
  void initState() {
    super.initState();
    checkPermission();
  }
  checkPermission(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(1, 1)),
      ),
    );
  }
}
