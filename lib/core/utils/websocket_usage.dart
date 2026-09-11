// WEBSOCKET HELPER USAGE GUIDE

// ============================================
// 1. BASIC SETUP IN YOUR WIDGET
// ============================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/websocket_bloc/websocket_bloc_index.dart';

class MyWebSocketPage extends StatefulWidget {
  const MyWebSocketPage({Key? key}) : super(key: key);

  @override
  State<MyWebSocketPage> createState() => _MyWebSocketPageState();
}

class _MyWebSocketPageState extends State<MyWebSocketPage> {
  late WebSocketBloc _webSocketBloc;

  @override
  void initState() {
    super.initState();
    _webSocketBloc = WebSocketBloc();
    
    // Connect to WebSocket server
    _webSocketBloc.add(
      const WebSocketConnectEvent(
        url: 'ws://localhost:8080',
        // Optional headers
        headers: {
          'Authorization': 'Bearer token_here',
        },
      ),
    );
  }

  @override
  void dispose() {
    _webSocketBloc.add(const WebSocketDisconnectEvent());
    _webSocketBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WebSocketBloc>(
      create: (context) => _webSocketBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Example')),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connected to WebSocket')),
          );
        } else if (state is WebSocketDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Disconnected from WebSocket')),
          );
        } else if (state is WebSocketError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMsg}')),
          );
        }
      },
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status indicator
              _buildStatusIndicator(state),
              const SizedBox(height: 20),
              
              // Message list
              _buildMessageList(context),
              const SizedBox(height: 20),
              
              // Send message button
              _buildSendButtons(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(WebSocketState state) {
    Color color = Colors.grey;
    String status = 'Disconnected';

    if (state is WebSocketConnecting) {
      color = Colors.orange;
      status = 'Connecting...';
    } else if (state is WebSocketConnected) {
      color = Colors.green;
      status = 'Connected';
    } else if (state is WebSocketError) {
      color = Colors.red;
      status = 'Error: ${state.errorMsg}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketMessageReceived) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message Received'),
                  subtitle: Text(state.message.toString()),
                );
              },
            );
          }
          return const Center(
            child: Text('No messages received yet'),
          );
        },
      ),
    );
  }

  Widget _buildSendButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<WebSocketBloc>().add(
              const WebSocketSendMessageEvent('Hello WebSocket!'),
            );
          },
          child: const Text('Send Message'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<WebSocketBloc>().add(
              WebSocketSendJsonEvent({
                'type': 'notification',
                'data': {'message': 'Hello from Flutter'},
              }),
            );
          },
          child: const Text('Send JSON'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<WebSocketBloc>().add(
              const WebSocketReconnectEvent(),
            );
          },
          child: const Text('Reconnect'),
        ),
      ],
    );
  }
}
*/

// ============================================
// 2. USING WEBSOCKET HELPER DIRECTLY
// ============================================

/*
import 'package:core/utils/websocket_helper.dart';

void main() {
  final webSocketHelper = WebSocketHelper();

  // Connect
  await webSocketHelper.connect(url: 'ws://localhost:8080');

  // Send message
  webSocketHelper.send('Hello!');

  // Send JSON
  webSocketHelper.sendJson({'type': 'hello', 'data': 'world'});

  // Listen to messages
  webSocketHelper.onMessage((message) {
    print('Received: $message');
  });

  // Listen to status changes
  webSocketHelper.onStatusChange((status) {
    print('Status: $status');
  });

  // Disconnect
  await webSocketHelper.disconnect();

  // Dispose
  await webSocketHelper.dispose();
}
*/

// ============================================
// 3. HANDLING DIFFERENT STATE TYPES
// ============================================

/*
BlocListener<WebSocketBloc, WebSocketState>(
  listener: (context, state) {
    if (state is WebSocketInitial) {
      // Initial state
    } else if (state is WebSocketConnecting) {
      // Show loading indicator
    } else if (state is WebSocketConnected) {
      // Connected, show UI for sending messages
    } else if (state is WebSocketDisconnected) {
      // Show disconnect message
    } else if (state is WebSocketMessageReceived) {
      // Handle received message
      final message = state.message;
      // Process message
    } else if (state is WebSocketMessageSent) {
      // Show confirmation
    } else if (state is WebSocketReconnecting) {
      // Show reconnecting indicator
    } else if (state is WebSocketStatusChanged) {
      // Handle status change (WebSocketStatus.connecting, connected, etc)
    } else if (state is WebSocketError) {
      // Handle error
      final errorMsg = state.errorMsg;
      final errorCode = state.errorCode;
      // Show error message
    } else if (state is WebSocketListeningStarted) {
      // Listening started
    } else if (state is WebSocketListeningStopped) {
      // Listening stopped
    }
  },
  child: Container(),
)
*/

// ============================================
// 4. COMPLETE EXAMPLE WITH MESSAGE STORAGE
// ============================================

/*
class WebSocketPageWithHistory extends StatefulWidget {
  const WebSocketPageWithHistory({Key? key}) : super(key: key);

  @override
  State<WebSocketPageWithHistory> createState() =>
      _WebSocketPageWithHistoryState();
}

class _WebSocketPageWithHistoryState extends State<WebSocketPageWithHistory> {
  late WebSocketBloc _webSocketBloc;
  final List<String> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _webSocketBloc = WebSocketBloc();
    
    // Connect on init
    _webSocketBloc.add(
      const WebSocketConnectEvent(url: 'ws://your-server.com/socket'),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _webSocketBloc.add(const WebSocketDisconnectEvent());
    _webSocketBloc.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    _webSocketBloc.add(WebSocketSendMessageEvent(message));
    _messages.add('You: $message');
    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WebSocketBloc>(
      create: (context) => _webSocketBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket Chat'),
          actions: [
            BlocBuilder<WebSocketBloc, WebSocketState>(
              builder: (context, state) {
                if (state is WebSocketConnected) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocListener<WebSocketBloc, WebSocketState>(
                listener: (context, state) {
                  if (state is WebSocketMessageReceived) {
                    setState(() {
                      _messages.add('Server: ${state.message}');
                    });
                  }
                },
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_messages[index]),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

// ============================================
// 5. FEATURES OVERVIEW
// ============================================

/*
WebSocket Helper Features:
- Singleton pattern for single connection instance
- Automatic connection management
- Message parsing (JSON and raw)
- Status tracking (connecting, connected, disconnected, error)
- Reconnection support
- Stream-based architecture
- Error handling with custom exceptions
- Debug logging

WebSocket BLoC Features:
- Extends BaseBloc with proper error state handling
- Complete event-driven architecture
- Multiple state types for different scenarios
- Automatic message and status stream subscription
- Resource cleanup on dispose
- Integration with Firebase analytics/crashlytics (via BaseBloc)
- Type-safe event and state management
- Easy integration with Flutter UI

Events:
- WebSocketConnectEvent: Connect to server
- WebSocketDisconnectEvent: Disconnect from server
- WebSocketSendMessageEvent: Send string message
- WebSocketSendJsonEvent: Send JSON message
- WebSocketMessageReceivedEvent: Internal event for received messages
- WebSocketStatusChangedEvent: Internal event for status changes
- WebSocketReconnectEvent: Reconnect to server
- WebSocketStartListeningEvent: Start message listening
- WebSocketStopListeningEvent: Stop message listening

States:
- WebSocketInitial: Initial state
- WebSocketConnecting: Connection in progress
- WebSocketConnected: Successfully connected
- WebSocketDisconnected: Disconnected
- WebSocketMessageReceived: Message received
- WebSocketMessageSent: Message sent
- WebSocketReconnecting: Reconnecting
- WebSocketStatusChanged: Status changed
- WebSocketError: Error occurred
- WebSocketListeningStarted: Started listening
- WebSocketListeningStopped: Stopped listening
*/
