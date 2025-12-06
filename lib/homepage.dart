// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   Completer<GoogleMapController> _controller = Completer();
//
//   // Start camera position
//   static final CameraPosition _kGoogle = const CameraPosition(
//     target: LatLng(23.6850, 90.3563),
//     zoom: 14.4746,
//   );
//
//   // Polyline coordinates (sample points)
//   final List<LatLng> polylineCoordinates = [
//     LatLng(23.6850, 90.3563), // Dhaka center
//     LatLng(23.7300, 90.3920), // Point B
//     LatLng(23.7500, 90.4200), // Point C
//   ];
//
//   final Set<Polyline> _polylines = {};
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Create polyline
//     _polylines.add(
//       Polyline(
//         polylineId: const PolylineId("route1"),
//         visible: true,
//         points: polylineCoordinates,
//         width: 5,
//         color: Colors.blue,
//       ),
//     );
//
//     // Create markers
//     _markers.add(
//       const Marker(
//         markerId: MarkerId("startPoint"),
//         position: LatLng(23.6850, 90.3563),
//         infoWindow: InfoWindow(title: "Start Point"),
//       ),
//     );
//
//     _markers.add(
//       const Marker(
//         markerId: MarkerId("endPoint"),
//         position: LatLng(23.7500, 90.4200),
//         infoWindow: InfoWindow(title: "End Point"),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0F9D58),
//         title: const Text("Map + Polyline + Markers"),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: _kGoogle,
//         mapType: MapType.normal,
//         myLocationEnabled: true,
//         compassEnabled: true,
//
//         // Add polyline
//         polylines: _polylines,
//
//         // Add markers
//         markers: _markers,
//
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }
