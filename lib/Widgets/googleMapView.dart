import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  final CameraPosition cameraPosition;
  final Function(double, double) setLocation;
  const GoogleMapView(
      {Key? key, required this.cameraPosition, required this.setLocation})
      : super(key: key);

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _mapCompleter = Completer();
  Set<Marker> markers = {};

  setPosition(double latitude, double longitude) {
    CameraPosition position = getPosition(latitude, longitude);
    moveCamera(position);
    markers.add(Marker(
        markerId: const MarkerId('senderLocation'),
        draggable: true,
        onDragEnd: (location) =>
            setLocation(location.latitude, location.longitude),
        position: LatLng(latitude, longitude)));
  }

  setLocation(double latitude, double longitude) async {
    setPosition(latitude, longitude);
    widget.setLocation(latitude, longitude);
  }

  moveCamera(CameraPosition position) async {
    final GoogleMapController googleMapController = await _mapCompleter.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  getPosition(double latitude, double longitude) {
    return CameraPosition(target: LatLng(latitude, longitude), zoom: 15.4746);
  }

  @override
  void initState() {
    super.initState();
    setPosition(widget.cameraPosition.target.latitude,
        widget.cameraPosition.target.longitude);
  }

  @override
  void didUpdateWidget(covariant GoogleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cameraPosition != oldWidget.cameraPosition) {
      setPosition(widget.cameraPosition.target.latitude,
          widget.cameraPosition.target.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: widget.cameraPosition,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) =>
          _mapCompleter.complete(controller),
      markers: markers,
    );
  }
}
