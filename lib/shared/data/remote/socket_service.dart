import 'package:socket_io_client/socket_io_client.dart';

class SocketIOService {
  final String url;
  final String address;
  late final Socket _socket;

  SocketIOService(this.url, this.address) {
    _connect();
  }

  void _connect() {
    _socket = io(
        url,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {});

    _socket.onDisconnect((_) {});

    _socket.onError((error) {});
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void dispose() {
    _socket.dispose();
  }
}
