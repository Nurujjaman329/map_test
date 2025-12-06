// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:map_test/real_map_test_api/app/controllers/map_controller.dart';
// import 'package:map_test/real_map_test_api/app/widgets/custom_search_bar.dart';
//
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final MapController controller = MapController();
//   GoogleMapController? mapController;
//   Marker? originMarker;
//   Marker? destinationMarker;
//   bool showDestinationSearch = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Step-by-Step Map')),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 12),
//             onMapCreated: (ctrl) => mapController = ctrl,
//             markers: {
//               if (originMarker != null) originMarker!,
//               if (destinationMarker != null) destinationMarker!,
//             },
//             polylines: {
//               if (controller.polylineCoordinates.isNotEmpty)
//                 Polyline(
//                   polylineId: PolylineId('route'),
//                   points: controller.polylineCoordinates,
//                   color: Colors.blue,
//                   width: 5,
//                 ),
//             },
//             onTap: (latLng) {
//               // Optionally tap map to select origin
//               originMarker = Marker(
//                 markerId: MarkerId('origin'),
//                 position: latLng,
//                 infoWindow: InfoWindow(
//                   title: 'Selected location',
//                   snippet: 'Tap to use as origin',
//                   onTap: () {
//                     controller.originController.text = '${latLng.latitude}, ${latLng.longitude}';
//                     setState(() {
//                       showDestinationSearch = true;
//                     });
//                   },
//                 ),
//               );
//               mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
//               setState(() {});
//             },
//           ),
//
//           // UI overlay
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Column(
//               children: [
//                 // Origin search
//                 Stack(
//                   children: [
//                     CustomSearchBar(
//                       controller: controller.originController,
//                       onChanged: (query) async {
//                         await controller.searchOrigin(query);
//                         setState(() {});
//                       },
//                     ),
//                     if (controller.originSearchResults.isNotEmpty)
//                       Container(
//                         margin: EdgeInsets.only(top: 50),
//                         color: Colors.white,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: controller.originSearchResults.length,
//                           itemBuilder: (context, index) {
//                             var place = controller.originSearchResults[index];
//                             return ListTile(
//                               title: Text(place['description']),
//                               onTap: () async {
//                                 controller.originController.text = place['description'];
//                                 controller.clearOriginResults();
//                                 LatLng? pos = await controller.getLatLng(place['description']);
//                                 if (pos != null) {
//                                   originMarker = Marker(
//                                     markerId: MarkerId('origin'),
//                                     position: pos,
//                                     infoWindow: InfoWindow(title: 'Origin'),
//                                   );
//                                   mapController?.animateCamera(CameraUpdate.newLatLng(pos));
//                                   setState(() {
//                                     showDestinationSearch = true;
//                                   });
//                                 }
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//
//                 SizedBox(height: 10),
//
//                 // Destination search
//                 if (showDestinationSearch)
//                   Stack(
//                     children: [
//                       CustomSearchBar(
//                         controller: controller.destinationController,
//                         onChanged: (query) async {
//                           await controller.searchDestination(query);
//                           setState(() {});
//                         },
//                       ),
//                       if (controller.destinationSearchResults.isNotEmpty)
//                         Container(
//                           margin: EdgeInsets.only(top: 50),
//                           color: Colors.white,
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: controller.destinationSearchResults.length,
//                             itemBuilder: (context, index) {
//                               var place = controller.destinationSearchResults[index];
//                               return ListTile(
//                                 title: Text(place['description']),
//                                 onTap: () async {
//                                   controller.destinationController.text = place['description'];
//                                   controller.clearDestinationResults();
//                                   LatLng? pos = await controller.getLatLng(place['description']);
//                                   if (pos != null) {
//                                     destinationMarker = Marker(
//                                       markerId: MarkerId('destination'),
//                                       position: pos,
//                                       infoWindow: InfoWindow(title: 'Destination'),
//                                     );
//                                     await controller.getDirections();
//                                     mapController?.animateCamera(
//                                       CameraUpdate.newLatLngBounds(
//                                         _boundsFromLatLngList(controller.polylineCoordinates),
//                                         50,
//                                       ),
//                                     );
//                                     setState(() {});
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//
//                 SizedBox(height: 10),
//
//                 // Distance/Duration
//                 if (controller.distanceText.isNotEmpty && controller.durationText.isNotEmpty)
//                   Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.all(8),
//                     child: Text(
//                       'Distance: ${controller.distanceText}, Duration: ${controller.durationText}',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double x0 = list[0].latitude;
//     double x1 = list[0].latitude;
//     double y0 = list[0].longitude;
//     double y1 = list[0].longitude;
//
//     for (LatLng latLng in list) {
//       if (latLng.latitude > x1) x1 = latLng.latitude;
//       if (latLng.latitude < x0) x0 = latLng.latitude;
//       if (latLng.longitude > y1) y1 = latLng.longitude;
//       if (latLng.longitude < y0) y0 = latLng.longitude;
//     }
//     return LatLngBounds(
//       southwest: LatLng(x0, y0),
//       northeast: LatLng(x1, y1),
//     );
//   }
// }
