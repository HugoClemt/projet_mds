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
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
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
    print('Messages: $messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isSentByHuman = message['is_sent_by_human'];
                return Align(
                  alignment: isSentByHuman
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSentByHuman)
                              const Icon(Icons.person, color: Colors.white),
                            if (!isSentByHuman)
                              const Icon(Icons.android, color: Colors.black),
                            const SizedBox(width: 5),
                            Text(
                              message['created_at'],
                              style: TextStyle(
                                color:
                                    isSentByHuman ? Colors.white : Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
