part of 'websocket_bloc.dart';

/// Base state for WebSocket BLoC
abstract class WebSocketState extends ErrorState {
}

/// Initial state of WebSocket BLoC
class WebSocketInitial extends WebSocketState {
}

/// State when WebSocket is connecting
class WebSocketConnecting extends WebSocketState {
}

/// State when WebSocket is connected successfully
class WebSocketConnected extends WebSocketState {
  WebSocketConnected({this.url});

  final String? url;
}

/// State when WebSocket is disconnected
class WebSocketDisconnected extends WebSocketState {
}

/// State when a message is received
class WebSocketMessageReceived extends WebSocketState {
  WebSocketMessageReceived(this.message);

  final dynamic message;
}

/// State when a message is sent successfully
class WebSocketMessageSent extends WebSocketState {
  WebSocketMessageSent({this.message});

  final String? message;
}

/// State when WebSocket is reconnecting
class WebSocketReconnecting extends WebSocketState {
  WebSocketReconnecting();
}

/// State when WebSocket status changes
class WebSocketStatusChanged extends WebSocketState {
  WebSocketStatusChanged(this.status);

  final WebSocketStatus status;
}

/// Error state for WebSocket operations
class WebSocketError extends WebSocketState {
  WebSocketError({
    this.errorMessage,
    this.errorCodeVal = 0,
    this.exception,
  });

  final String? errorMessage;
  final int errorCodeVal;
  final dynamic exception;

  @override
  String? get errorMsg => errorMessage;
}

/// State when listening to messages starts
class WebSocketListeningStarted extends WebSocketState {
}

/// State when listening to messages stops
class WebSocketListeningStopped extends WebSocketState {
}
