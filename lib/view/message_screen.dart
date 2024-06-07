import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final int conversationId;
  const MessageScreen({super.key, required this.conversationId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Center(
        child: Text(
            'Display messages for conversation ID: ${widget.conversationId}'),
      ),
    );
  }
}
