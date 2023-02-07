import 'dart:async';

import 'package:chatmate/Utilities/permissions.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareLocation extends StatefulWidget {
  const ShareLocation({Key? key}) : super(key: key);

  @override
  State<ShareLocation> createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng sourceLocation = LatLng(24.8607, 67.0011);
  static const LatLng destination = LatLng(25.8607, 67.0011);
  List<LatLng> polylineCoordinates = [];
  CameraPosition currentLocation = const CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 10.4746,
  );

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setLocation(position.latitude, position.longitude);
  }

  setLocation(double latitude, double longitude) {
    setState(() {
      sourceLocation = LatLng(latitude, longitude);
      currentLocation =
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15.4746);
    });
  }

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
            'AIzaSyB7cvQyueRyRcaPnO7CymDrfSTGbD-svis',
            PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
            PointLatLng(destination.latitude, destination.longitude));
    if (polylineResult.points.isNotEmpty) {
      polylineResult.points.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    print('checkingggg....');
    PermissionStatus permissionStatus =
        await PermissionsHelper.requestPermisison(Permission.location);
    if (permissionStatus == PermissionStatus.granted) {
      print('if permissionStatus = ${permissionStatus.toString()}');
      bool isGPSEnabled = await PermissionsHelper.checkGps(context);
      isGPSEnabled ? getCurrentLocation() : Navigator.pop(context);
      await getPolyPoints();
    } else {
      print('else permissionStatus = ${permissionStatus.toString()}');
    }
  }

moveCamera(){
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: currentLocation,
        polylines: {
          Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: ThemeColors.primaryColor,
              width: 6)
        },

        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}
