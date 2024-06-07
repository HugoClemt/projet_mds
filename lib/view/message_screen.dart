import 'package:flutter/material.dart';
import 'package:projet_mds/service/message_service.dart';

class MessageScreen extends StatefulWidget {
  final int conversationId;
  const MessageScreen({super.key, required this.conversationId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      print('Sending message: $messageText');
      final response = await _messageService.sendMessage(
          messageText, widget.conversationId.toString());
      if (response.success) {
        print('Message sent successfully');
        _messageController.clear();
        _loadMessages();
      } else {
        print('Failed to send message: ${response.message}');
      }
    }
  }

  void _loadMessages() async {
    final messages =
        await _messageService.getMessages(widget.conversationId.toString());
    setState(() {
      _messages = messages;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    print('Messages: $messages');
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _refreshMessages() async {
    await _messageService.refreshMessages(widget.conversationId.toString());
    _loadMessages();
  }

  Widget _buildMessage(BuildContext context, Map<String, dynamic> message) {
    bool isSentByHuman = message['is_sent_by_human'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByHuman ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSentByHuman) ...[
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.android, color: Colors.black),
            ),
            const SizedBox(width: 10),
          ],
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSentByHuman ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['content'],
                  style: TextStyle(
                    color: isSentByHuman ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message['created_at'],
                  style: TextStyle(
                    color: isSentByHuman ? Colors.white : Colors.black,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isSentByHuman) ...[
            const SizedBox(width: 10),
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(context, message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  onPressed: _refreshMessages,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
