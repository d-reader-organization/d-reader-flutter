import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
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
    ref.read(environmentProvider).apiUrl,
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  ref.onDispose(() {
    socket.dispose();
  });
  return SocketState(socket: socket);
});
