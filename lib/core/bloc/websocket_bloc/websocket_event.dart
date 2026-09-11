part of 'websocket_bloc.dart';

/// Base event for WebSocket operations
abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object?> get props => [];
}

/// Event to connect to WebSocket server
class WebSocketConnectEvent extends WebSocketEvent {
  const WebSocketConnectEvent({
    required this.url,
    this.headers,
  });

  final String url;
  final Map<String, dynamic>? headers;

  @override
  List<Object?> get props => [url, headers];
}

/// Event to disconnect from WebSocket server
class WebSocketDisconnectEvent extends WebSocketEvent {
  const WebSocketDisconnectEvent();

  @override
  List<Object?> get props => [];
}

/// Event to send a message through WebSocket
class WebSocketSendMessageEvent extends WebSocketEvent {
  const WebSocketSendMessageEvent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Event to send a JSON message through WebSocket
class WebSocketSendJsonEvent extends WebSocketEvent {
  const WebSocketSendJsonEvent(this.data);

  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [data];
}

/// Event triggered when a message is received
class WebSocketMessageReceivedEvent extends WebSocketEvent {
  const WebSocketMessageReceivedEvent(this.message);

  final dynamic message;

  @override
  List<Object?> get props => [message];
}

/// Event triggered when WebSocket status changes
class WebSocketStatusChangedEvent extends WebSocketEvent {
  const WebSocketStatusChangedEvent(this.status);

  final WebSocketStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to reconnect to WebSocket server
class WebSocketReconnectEvent extends WebSocketEvent {
  const WebSocketReconnectEvent();

  @override
  List<Object?> get props => [];
}

/// Event to listen to incoming messages
class WebSocketStartListeningEvent extends WebSocketEvent {
  const WebSocketStartListeningEvent();

  @override
  List<Object?> get props => [];
}

/// Event to stop listening to incoming messages
class WebSocketStopListeningEvent extends WebSocketEvent {
  const WebSocketStopListeningEvent();

  @override
  List<Object?> get props => [];
}
