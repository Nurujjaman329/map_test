import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  /// GET request to httpbin.org
  Future<Map<String, dynamic>> getRequest() async {
    final url = Uri.parse("https://httpbin.org/get");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("GET request failed: ${response.statusCode}");
    }
  }

  /// POST request to httpbin.org
  Future<Map<String, dynamic>> postRequest() async {
    final url = Uri.parse("https://httpbin.org/post");

    final response = await http.post(
      url,
      body: {"name": "Flutter", "type": "demo"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("POST request failed: ${response.statusCode}");
    }
  }
}
