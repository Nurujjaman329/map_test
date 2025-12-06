import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LiveUserMap extends StatefulWidget {
  const LiveUserMap({super.key});

  @override
  State<LiveUserMap> createState() => _LiveUserMapState();
}

class _LiveUserMapState extends State<LiveUserMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // Live user marker
  Marker? userMarker;

  // Polyline for user path
  final List<LatLng> pathCoordinates = [];
  Set<Polyline> _polylines = {};

  // Initial camera position (Dhaka)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(23.6850, 90.3563),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    // Listen to position updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update every 5 meters
      ),
    ).listen((Position position) async {
      LatLng pos = LatLng(position.latitude, position.longitude);

      // Add to path
      pathCoordinates.add(pos);

      // Update polyline
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("user_path"),
          visible: true,
          points: pathCoordinates,
          width: 5,
          color: Colors.blue,
        ),
      );

      // Update marker
      userMarker = Marker(
        markerId: const MarkerId("user"),
        position: pos,
        infoWindow: const InfoWindow(title: "You"),
      );

      setState(() {});

      // Move camera
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 17),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live User Movement"),
        backgroundColor: const Color(0xFF0F9D58),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
        compassEnabled: true,
        markers: userMarker != null ? {userMarker!} : {},
        polylines: _polylines,
        onMapCreated: (controller) => _controller.complete(controller),
      ),
    );
  }
}
