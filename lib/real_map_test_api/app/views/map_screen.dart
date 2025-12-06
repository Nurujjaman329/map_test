import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';
import 'location_search_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController controller = Get.find<MapController>();
  GoogleMapController? googleMapController;
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();

    // Automatically animate to origin when it changes
    ever(controller.originLatLng, (LatLng? value) {
      if (value != null && googleMapController != null) {
        _animateToLocation(value);
      }
    });

    // Automatically animate to destination when it changes
    ever(controller.destinationLatLng, (LatLng? value) {
      if (value != null && googleMapController != null) {
        _animateToLocation(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Route Navigator',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      body: Stack(
        children: [
          // ======================= MAP =======================
          _buildMap(),

          // ======================= LOCATION CARDS =======================
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // ORIGIN CARD
                Obx(() => _locationCard(
                  icon: Icons.circle,
                  iconColor: Colors.green,
                  title: 'Starting Point',
                  address: controller.originText.value,
                  onTap: () {
                    controller.setSearchType('origin');
                    Get.to(() => LocationSearchScreen());
                  },
                  onClear: controller.clearOrigin,
                )),
                const SizedBox(height: 12),

                // DESTINATION CARD
                Obx(() => _locationCard(
                  icon: Icons.flag,
                  iconColor: Colors.red,
                  title: 'Destination',
                  address: controller.destinationText.value,
                  onTap: () {
                    controller.setSearchType('destination');
                    Get.to(() => LocationSearchScreen());
                  },
                  onClear: controller.clearDestination,
                )),

                // DISTANCE + DURATION CARD
                Obx(() {
                  if (controller.distanceText.isNotEmpty &&
                      controller.durationText.isNotEmpty) {
                    return _distanceDurationCard();
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),

          // ======================= ACTION BUTTONS =======================
          Positioned(
            bottom: 100,
            right: 20,
            child: Column(
              children: [
                // Get Directions Button
                FloatingActionButton(
                  heroTag: 'directions',
                  onPressed: () async {
                    if (controller.originText.value.isEmpty) {
                      controller.setSearchType('origin');
                      await Get.to(() => LocationSearchScreen());
                      return;
                    }

                    if (controller.destinationText.value.isEmpty) {
                      controller.setSearchType('destination');
                      await Get.to(() => LocationSearchScreen());
                      return;
                    }

                    if (controller.originText.value.isNotEmpty &&
                        controller.destinationText.value.isNotEmpty) {
                      await controller.getDirections();
                      _zoomToRoute();
                    }
                  },
                  backgroundColor: Colors.blue.shade600,
                  child: const Icon(Icons.directions, color: Colors.white),
                ),
                const SizedBox(height: 12),

                // Zoom to Origin
                FloatingActionButton.small(
                  heroTag: 'origin',
                  onPressed: () {
                    if (controller.originLatLng.value != null) {
                      _animateToLocation(controller.originLatLng.value!);
                    }
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.location_on, color: Colors.green),
                ),
                const SizedBox(height: 8),

                // Zoom to Destination
                FloatingActionButton.small(
                  heroTag: 'destination',
                  onPressed: () {
                    if (controller.destinationLatLng.value != null) {
                      _animateToLocation(controller.destinationLatLng.value!);
                    }
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.flag, color: Colors.red),
                ),
                const SizedBox(height: 8),

                // Zoom to Fit Route
                FloatingActionButton.small(
                  heroTag: 'fit',
                  onPressed: () {
                    if (controller.polylineCoordinates.isNotEmpty) {
                      _zoomToRoute();
                    }
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.zoom_out_map, color: Colors.blue.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // MAP WIDGET
  // ===========================================================
  Widget _buildMap() {
    return Obx(() {
      final origin = controller.originLatLng.value;
      final destination = controller.destinationLatLng.value;
      final polyline = controller.polylineCoordinates;

      return GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (ctrl) => googleMapController = ctrl,
        markers: _buildMarkers(origin, destination),
        polylines: _buildPolylines(polyline),
        onTap: _showLocationOptions,
      );
    });
  }

  Set<Marker> _buildMarkers(LatLng? origin, LatLng? destination) {
    final markers = <Marker>{};
    if (origin != null) {
      markers.add(Marker(
        markerId: const MarkerId('origin'),
        position: origin,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
    if (destination != null) {
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
    return markers;
  }

  Set<Polyline> _buildPolylines(List<LatLng> polyline) {
    if (polyline.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: polyline,
        color: Colors.blue.shade600,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      )
    };
  }

  // ===========================================================
  // LOCATION CARD WIDGET
  // ===========================================================
  Widget _locationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    address.isEmpty ? 'Tap to select $title' : address,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                      address.isEmpty ? Colors.grey.shade400 : Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (address.isNotEmpty)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.clear, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _distanceDurationCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoItem(Icons.alt_route, "Distance", controller.distanceText.value),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _infoItem(Icons.access_time, "Duration", controller.durationText.value),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue.shade600, size: 16),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            )),
      ],
    );
  }

  void _zoomToRoute() {
    if (controller.polylineCoordinates.isEmpty || googleMapController == null) return;
    googleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(_boundsFromLatLngList(controller.polylineCoordinates), 100),
    );
  }

  void _showLocationOptions(LatLng latLng) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Use this location as:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.green),
                title: const Text('Starting Point'),
                onTap: () {
                  Get.back();
                  controller.setOrigin('Selected Location', latLng);
                  _animateToLocation(latLng);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.red),
                title: const Text('Destination'),
                onTap: () {
                  Get.back();
                  controller.setDestination('Selected Location', latLng);
                  _animateToLocation(latLng);
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _animateToLocation(LatLng latLng) {
    googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    if (list.isEmpty) return LatLngBounds(southwest: LatLng(23.8103, 90.4125), northeast: LatLng(23.8103, 90.4125));

    double x0 = list.first.latitude;
    double x1 = x0;
    double y0 = list.first.longitude;
    double y1 = y0;

    for (var latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }
}
