import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Geocoding: address -> LatLng
  static Future<Map<String, dynamic>?> geocode(String address) async {
    final url = Uri.parse('${ApiConstants.geocodingUrl}?address=$address&key=${ApiConstants.googleApiKey}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['results'][0]['geometry']['location'];
    }
    return null;
  }

  // Reverse Geocoding: LatLng -> address
  static Future<String?> reverseGeocode(double lat, double lng) async {
    final url = Uri.parse('${ApiConstants.reverseGeocodingUrl}?latlng=$lat,$lng&key=${ApiConstants.googleApiKey}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['results'][0]['formatted_address'];
    }
    return null;
  }

  // Places Autocomplete: for search suggestions
  static Future<List> searchPlaces(String input) async {
    final url = Uri.parse('${ApiConstants.placesAutocompleteUrl}?input=$input&key=${ApiConstants.googleApiKey}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['predictions'];
    }
    return [];
  }

  // Place Details
  static Future<Map<String, dynamic>?> placeDetails(String placeId) async {
    final url = Uri.parse('${ApiConstants.placeDetailsUrl}?place_id=$placeId&key=${ApiConstants.googleApiKey}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['result'];
    }
    return null;
  }

  // Directions
  static Future<Map<String, dynamic>?> getDirections(String origin, String destination) async {
    final url = Uri.parse('${ApiConstants.directionsUrl}?origin=$origin&destination=$destination&key=${ApiConstants.googleApiKey}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['routes'][0];
    }
    return null;
  }
}
