import 'package:flutter/material.dart';
import 'websocket_service.dart';
import 'http_service.dart';
import 'notification_service.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ws = WebSocketService();
  final httpService = HttpService();

  String wsMessage = "";
  Map<String, dynamic> httpResponse = {};

  @override
  void initState() {
    super.initState();

    // Connect to WebSocket
    ws.connect();

    // Listen for incoming WebSocket messages
    ws.stream.listen((msg) {
      setState(() => wsMessage = msg);
      NotificationService.show(title: "WebSocket Message", body: msg);
    });
  }

  @override
  void dispose() {
    ws.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket + HTTP Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------ WEBSOCKET -------------------
              const Text("WebSocket", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text("Received: $wsMessage"),
              TextField(
                onSubmitted: (value) {
                  ws.sendMessage(value);
                  setState(() {
                    wsMessage = "Me: $value"; // optional echo
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Send WebSocket message",
                ),
              ),
              const SizedBox(height: 20),

              //------------------ HTTP -------------------------
              const Text("HTTP Echo", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade200,
                width: double.infinity,
                child: Text(
                  httpResponse.isEmpty
                      ? "No response yet"
                      : const JsonEncoder.withIndent('  ').convert(
                    httpResponse,
                  ),
                  style: const TextStyle(fontFamily: 'Courier'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        Map<String, dynamic> res =
                        await httpService.getRequest();
                        setState(() => httpResponse = res);
                      } catch (e) {
                        setState(() =>
                        httpResponse = {"error": e.toString()});
                      }
                    },
                    child: const Text("GET"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        Map<String, dynamic> res =
                        await httpService.postRequest();
                        setState(() => httpResponse = res);
                      } catch (e) {
                        setState(() =>
                        httpResponse = {"error": e.toString()});
                      }
                    },
                    child: const Text("POST"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
