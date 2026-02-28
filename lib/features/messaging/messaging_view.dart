import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class MessagingView extends ConsumerStatefulWidget {
  const MessagingView({super.key});

  @override
  ConsumerState<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends ConsumerState<MessagingView> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late RealtimeChannel _channel;
  final String _roomId = 'global_lounge'; // Default Room ID as discussed
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _setupRealtime();
  }

  void _setupRealtime() {
    final supabase = Supabase.instance.client;
    
    // 1. Initialize the channel
    _channel = supabase.channel('room:$_roomId:messages', opts: const RealtimeChannelConfig(private: true));

    // 2. Listen for 'broadcast' events with type 'message_created'
    _channel.onBroadcast(
      event: 'message_created',
      callback: (payload) {
        if (mounted) {
          setState(() {
            _messages.add({
              'body': payload['body'],
              'user_id': payload['user_id'],
              'timestamp': DateTime.now().toIso8601String(),
              'is_me': payload['user_id'] == supabase.auth.currentUser?.id || payload['user_id'] == 'tester_id',
            });
          });
        }
      },
    );

    // 3. Subscribe to the channel
    _channel.subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        setState(() => _isConnected = true);
        print('DEBUG: Subscribed to room $_roomId');
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id ?? 'tester_id'; // Guest fallback

    // Map logic from user's snippet: channel.send(...)
    await _channel.sendBroadcast(
      event: 'message_created',
      payload: {
        'body': text,
        'user_id': userId,
      },
    );

    setState(() {
      _messages.add({
        'body': text,
        'user_id': userId,
        'timestamp': DateTime.now().toIso8601String(),
        'is_me': true,
      });
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Community Lounge', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              _isConnected ? '● Connected' : '○ Connecting...',
              style: TextStyle(fontSize: 12, color: _isConnected ? Colors.green : Colors.grey),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['is_me'] == true;
                return _buildMessageBubble(msg['body'], isMe);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFCE3132) : Colors.white10,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2C2C2C),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withAlpha(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: Color(0xFFCE3132)),
          ),
        ],
      ),
    );
  }
}
