import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base_bloc/base_bloc.dart';
import '../../utils/websocket_helper.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

/// WebSocket BLoC for managing WebSocket connections and communications
/// Extends BaseBloc with proper error state handling and event processing
class WebSocketBloc extends BaseBloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc() : super(WebSocketInitial()) {
    _webSocketHelper = WebSocketHelper();
    _setupEventHandlers();
  }

  late final WebSocketHelper _webSocketHelper;
  StreamSubscription<dynamic>? _messageSubscription;
  StreamSubscription<WebSocketStatus>? _statusSubscription;

  /// Setup all event handlers
  void _setupEventHandlers() {
    on<WebSocketConnectEvent>(_onConnect);
    on<WebSocketDisconnectEvent>(_onDisconnect);
    on<WebSocketSendMessageEvent>(_onSendMessage);
    on<WebSocketSendJsonEvent>(_onSendJson);
    on<WebSocketReconnectEvent>(_onReconnect);
    on<WebSocketStartListeningEvent>(_onStartListening);
    on<WebSocketStopListeningEvent>(_onStopListening);
  }

  /// Handle connect event
  Future<void> _onConnect(
    WebSocketConnectEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      emit(WebSocketConnecting());

      await _webSocketHelper.connect(
        url: event.url,
        headers: event.headers,
        onError: (error) {
          emit(
            WebSocketError(
              errorMessage: 'Connection error: $error',
              errorCodeVal: -1,
              exception: error,
            ),
          );
        },
      );

      emit(WebSocketConnected(url: event.url));

      // Start listening to status changes
      _statusSubscription = _webSocketHelper.onStatusChange((status) {
        add(WebSocketStatusChangedEvent(status));
      });

      // Start listening to messages
      _messageSubscription = _webSocketHelper.onMessage((message) {
        add(WebSocketMessageReceivedEvent(message));
      });

      debugPrint('WebSocket BLoC: Connected to ${event.url}');
    } on WebSocketException catch (e) {
      emit(
        WebSocketError(
          errorMessage: e.message,
          errorCodeVal: -1,
          exception: e,
        ),
      );
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Unexpected error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle disconnect event
  Future<void> _onDisconnect(
    WebSocketDisconnectEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      await _messageSubscription?.cancel();
      await _statusSubscription?.cancel();
      await _webSocketHelper.disconnect();

      emit(WebSocketDisconnected());
      debugPrint('WebSocket BLoC: Disconnected');
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Disconnect error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle send message event
  Future<void> _onSendMessage(
    WebSocketSendMessageEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      if (!_webSocketHelper.isConnected) {
        throw WebSocketException('WebSocket not connected');
      }

      _webSocketHelper.send(event.message);
      emit(WebSocketMessageSent(message: event.message));
      debugPrint('WebSocket BLoC: Message sent');
    } on WebSocketException catch (e) {
      emit(
        WebSocketError(
          errorMessage: e.message,
          errorCodeVal: -1,
          exception: e,
        ),
      );
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Send message error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle send JSON event
  Future<void> _onSendJson(
    WebSocketSendJsonEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      if (!_webSocketHelper.isConnected) {
        throw WebSocketException('WebSocket not connected');
      }

      _webSocketHelper.sendJson(event.data);
      emit(WebSocketMessageSent());
      debugPrint('WebSocket BLoC: JSON message sent');
    } on WebSocketException catch (e) {
      emit(
        WebSocketError(
          errorMessage: e.message,
          errorCodeVal: -1,
          exception: e,
        ),
      );
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Send JSON error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle reconnect event
  Future<void> _onReconnect(
    WebSocketReconnectEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      emit(WebSocketReconnecting());

      await _messageSubscription?.cancel();
      await _statusSubscription?.cancel();

      await _webSocketHelper.reconnect(
        onError: (error) {
          emit(
            WebSocketError(
              errorMessage: 'Reconnection error: $error',
              errorCodeVal: -1,
              exception: error,
            ),
          );
        },
      );

      emit(WebSocketConnected(url: _webSocketHelper.currentUrl));

      // Restart listening
      _statusSubscription = _webSocketHelper.onStatusChange((status) {
        add(WebSocketStatusChangedEvent(status));
      });

      _messageSubscription = _webSocketHelper.onMessage((message) {
        add(WebSocketMessageReceivedEvent(message));
      });

      debugPrint('WebSocket BLoC: Reconnected');
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Reconnect error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle start listening event
  Future<void> _onStartListening(
    WebSocketStartListeningEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      if (_messageSubscription != null) {
        emit(WebSocketListeningStarted());
        return;
      }

      _messageSubscription = _webSocketHelper.onMessage((message) {
        add(WebSocketMessageReceivedEvent(message));
      });

      emit(WebSocketListeningStarted());
      debugPrint('WebSocket BLoC: Started listening to messages');
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Listen error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Handle stop listening event
  Future<void> _onStopListening(
    WebSocketStopListeningEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    try {
      await _messageSubscription?.cancel();
      _messageSubscription = null;

      emit(WebSocketListeningStopped());
      debugPrint('WebSocket BLoC: Stopped listening to messages');
    } catch (error) {
      emit(
        WebSocketError(
          errorMessage: 'Stop listening error: $error',
          errorCodeVal: -1,
          exception: error,
        ),
      );
    }
  }

  /// Override getErrorState to return WebSocketError
  @override
  WebSocketState getErrorState() {
    return WebSocketError(
      errorMessage: 'An error occurred',
    );
  }

  /// Override eventHandlerMethod (required by BaseBloc)
  @override
  Future<void> eventHandlerMethod(
    WebSocketEvent event,
    Emitter<WebSocketState> emit,
  ) async {
    // Event handling is done in individual handlers above
    // This method is required by BaseBloc but all logic is handled
    // in the on<Event> handlers
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    await _statusSubscription?.cancel();
    await _webSocketHelper.dispose();
    return super.close();
  }
}
