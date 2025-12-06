import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.org'),
    );
  }

  void sendMessage(String msg) {
    channel.sink.add(msg);
  }

  Stream get stream => channel.stream;

  void disconnect() {
    channel.sink.close();
  }
}
