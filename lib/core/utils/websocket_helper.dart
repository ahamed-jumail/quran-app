import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket Helper class for managing WebSocket connections
/// Provides functionality for connect, disconnect, send, and receive messages
class WebSocketHelper {

  factory WebSocketHelper() {
    return _instance;
  }
  WebSocketHelper._();

  static final WebSocketHelper _instance = WebSocketHelper._();

  WebSocketChannel? _channel;
  String? _url;
  bool _isConnected = false;
  StreamSubscription<dynamic>? _messageSubscription;

  // Stream controllers for message handling
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();
  final StreamController<WebSocketStatus> _statusController =
      StreamController<WebSocketStatus>.broadcast();

  /// Getters
  Stream<dynamic> get messageStream => _messageController.stream;
  Stream<WebSocketStatus> get statusStream => _statusController.stream;
  bool get isConnected => _isConnected;
  String? get currentUrl => _url;

  /// Connect to WebSocket server
  /// 
  /// Parameters:
  ///   - [url]: WebSocket server URL (e.g., 'ws://localhost:8080')
  ///   - [headers]: Optional headers for the connection
  ///   - [onError]: Optional callback for connection errors
  Future<void> connect({
    required String url,
    Map<String, dynamic>? headers,
    dynamic Function(dynamic error)? onError,
  }) async {
    try {
      if (_isConnected && _url == url) {
        debugPrint('WebSocket already connected to $url');
        _statusController.add(WebSocketStatus.connected);
        return;
      }

      _url = url;
      _statusController.add(WebSocketStatus.connecting);

      // Create WebSocket channel
      _channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      // Listen to incoming messages
      _messageSubscription = _channel!.stream.listen(
        (dynamic message) {
          _handleIncomingMessage(message);
        },
        onError: (dynamic error) {
          debugPrint('WebSocket Error: $error');
          _isConnected = false;
          _statusController.add(WebSocketStatus.error);
          if (onError != null) {
            onError(error);
          }
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _isConnected = false;
          _statusController.add(WebSocketStatus.disconnected);
        },
        cancelOnError: false,
      );

      _isConnected = true;
      _statusController.add(WebSocketStatus.connected);
      debugPrint('WebSocket connected to: $url');
    } catch (error) {
      debugPrint('WebSocket connection error: $error');
      _isConnected = false;
      _statusController.add(WebSocketStatus.error);
      if (onError != null) {
        onError(error);
      }
      rethrow;
    }
  }

  /// Send message through WebSocket
  /// 
  /// Parameters:
  ///   - [message]: String message to send
  void send(String message) {
    if (!_isConnected || _channel == null) {
      throw WebSocketException('WebSocket not connected');
    }

    try {
      _channel!.sink.add(message);
      debugPrint('Message sent: $message');
    } catch (error) {
      debugPrint('Error sending message: $error');
      _statusController.add(WebSocketStatus.error);
      throw WebSocketException('Failed to send message: $error');
    }
  }

  /// Send JSON message through WebSocket
  /// 
  /// Parameters:
  ///   - [data]: Map to be converted to JSON
  void sendJson(Map<String, dynamic> data) {
    final String jsonString = jsonEncode(data);
    send(jsonString);
  }

  /// Internal method to handle incoming messages
  void _handleIncomingMessage(dynamic message) {
    try {
      // Try to parse as JSON
      if (message is String) {
        try {
          final dynamic decodedMessage = jsonDecode(message);
          _messageController.add(decodedMessage);
        } catch (e) {
          // If not valid JSON, add as raw string
          _messageController.add(message);
        }
      } else {
        _messageController.add(message);
      }
      debugPrint('Message received: $message');
    } catch (error) {
      debugPrint('Error handling incoming message: $error');
      _statusController.add(WebSocketStatus.error);
    }
  }

  /// Listen to messages with type-safe callback
  /// 
  /// Returns a StreamSubscription that can be canceled
  StreamSubscription<dynamic> onMessage(void Function(dynamic) callback) {
    return _messageController.stream.listen(callback);
  }

  /// Listen to connection status changes
  /// 
  /// Returns a StreamSubscription that can be canceled
  StreamSubscription<WebSocketStatus> onStatusChange(
    void Function(WebSocketStatus) callback,
  ) {
    return _statusController.stream.listen(callback);
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    try {
      // Cancel message subscription
      if (_messageSubscription != null) {
        await _messageSubscription!.cancel();
        _messageSubscription = null;
      }

      // Close the channel
      if (_channel != null) {
        await _channel!.sink.close();
        _channel = null;
      }

      _isConnected = false;
      _url = null;
      _statusController.add(WebSocketStatus.disconnected);
      debugPrint('WebSocket disconnected');
    } catch (error) {
      debugPrint('Error disconnecting WebSocket: $error');
      _statusController.add(WebSocketStatus.error);
    }
  }

  /// Dispose all resources
  Future<void> dispose() async {
    await disconnect();
    await _messageController.close();
    await _statusController.close();
  }

  /// Reconnect to the same server
  Future<void> reconnect({dynamic Function(dynamic error)? onError}) async {
    if (_url == null) {
      throw WebSocketException('No previous connection URL available');
    }

    await disconnect();
    await connect(url: _url!, onError: onError);
  }
}

/// WebSocket Status enum
enum WebSocketStatus {
  connecting,
  connected,
  disconnected,
  error,
}

/// Custom exception for WebSocket operations
class WebSocketException implements Exception {
  WebSocketException(this.message);

  final String message;

  @override
  String toString() => 'WebSocketException: $message';
}
