import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class MapController extends GetxController {
  // Text controllers
  final originController = TextEditingController();
  final destinationController = TextEditingController();

  // Reactive text for UI
  RxString originText = ''.obs;
  RxString destinationText = ''.obs;

  // Current search context
  RxString currentSearchType = 'origin'.obs;

  // Search results
  RxList searchResults = <dynamic>[].obs;

  // Selected locations
  Rx<LatLng?> originLatLng = Rx<LatLng?>(null);
  Rx<LatLng?> destinationLatLng = Rx<LatLng?>(null);

  // Route data
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  RxString distanceText = ''.obs;
  RxString durationText = ''.obs;

  // -----------------------------
  // Location Selection Methods
  // -----------------------------
  void setSearchType(String type) {
    currentSearchType.value = type;
  }

  Future<void> searchPlaces(String query) async {
    if (query.isNotEmpty) {
      var result = await ApiService.searchPlaces(query);
      searchResults.assignAll(result);
    } else {
      searchResults.clear();
    }
  }

  void clearSearchResults() => searchResults.clear();

  Future<LatLng?> getLatLng(String address) async {
    try {
      var data = await ApiService.geocode(address);
      if (data != null) return LatLng(data['lat'], data['lng']);
      return null;
    } catch (e) {
      print('Error getting LatLng: $e');
      return null;
    }
  }

  // -----------------------------
  // Location Setting Methods
  // -----------------------------
  Future<void> setOrigin(String address, LatLng latLng) async {
    originController.text = address;
    originText.value = address; // <-- reactive update
    originLatLng.value = latLng;

    if (destinationLatLng.value != null) {
      await getDirections();
    }
  }

  Future<void> setDestination(String address, LatLng latLng) async {
    destinationController.text = address;
    destinationText.value = address; // <-- reactive update
    destinationLatLng.value = latLng;

    if (originLatLng.value != null) {
      await getDirections();
    }
  }

  void clearOrigin() {
    originController.clear();
    originText.value = '';
    originLatLng.value = null;
    polylineCoordinates.clear();
    distanceText.value = '';
    durationText.value = '';
  }

  void clearDestination() {
    destinationController.clear();
    destinationText.value = '';
    destinationLatLng.value = null;
    polylineCoordinates.clear();
    distanceText.value = '';
    durationText.value = '';
  }

  void clearAll() {
    clearOrigin();
    clearDestination();
  }

  // -----------------------------
  // Directions Methods
  // -----------------------------
  Future<void> getDirections() async {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      Get.snackbar('Error', 'Please select both origin and destination');
      return;
    }

    try {
      final route = await ApiService.getDirections(
        originController.text,
        destinationController.text,
      );

      if (route != null) {
        polylineCoordinates.clear();

        distanceText.value = route['legs'][0]['distance']['text'];
        durationText.value = route['legs'][0]['duration']['text'];

        String encodedPolyline = route['overview_polyline']['points'];
        polylineCoordinates.assignAll(decodePolyline(encodedPolyline));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get directions: $e');
    }
  }

  // -----------------------------
  // Decode polyline
  // -----------------------------
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return polyline;
  }
}
