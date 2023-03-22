import 'package:d_reader_flutter/config/config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

@immutable // preferred to use immutable states
class SocketState {
  const SocketState({
    required this.socket,
  });
  final Socket socket;
  SocketState copyWith({required Socket socket}) {
    return SocketState(socket: socket);
  }
}

final socketProvider = StateProvider<SocketState>((ref) {
  Socket socket = io(
    Config.apiUrl,
    OptionBuilder().setTransports(['websocket']).build(),
  );
  return SocketState(socket: socket);
});
