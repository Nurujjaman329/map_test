import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class SearchMapPage extends StatefulWidget {
  const SearchMapPage({super.key});

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController searchController = TextEditingController();

  static const String apiKey = "AIzaSyBFi80uuJIWkkLCpodFa8oXmD8XD_h8LMc";

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.6850, 90.3563),
    zoom: 14,
  );

  Set<Marker> markers = {};

  // -- Autocomplete Places Search --
  Future<List<dynamic>> getLocationSuggestions(String input) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:bd";

    var response = await http.get(Uri.parse(url));
    var jsonResult = json.decode(response.body);

    return jsonResult['predictions'];
  }

  // -- Get coordinates from placeId --
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    var response = await http.get(Uri.parse(url));
    var result = json.decode(response.body);

    return result['result']['geometry']['location'];
  }

  _goToPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 16),
      ),
    );

    // Add marker
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("search_place"),
        position: LatLng(lat, lng),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Map"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            onMapCreated: (controller) => _controller.complete(controller),
            myLocationEnabled: true,
            compassEnabled: true,
          ),

          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: TypeAheadField(
              controller: searchController,
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];
                return await getLocationSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['description']),
                );
              },
              onSelected: (suggestion) async {
                searchController.text = suggestion['description'];

                var placeId = suggestion['place_id'];
                var placeDetails = await getPlaceDetails(placeId);

                double lat = placeDetails['lat'];
                double lng = placeDetails['lng'];

                _goToPlace(lat, lng);
              },
              decorationBuilder: (context, child) {
                return Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                );
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search place...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
