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

final socketProvider =
    StateProvider.family<SocketState, String>((ref, socketUri) {
  Socket socket = io(
    socketUri,
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  ref.onDispose(() {
    socket.dispose();
  });
  return SocketState(socket: socket);
});
