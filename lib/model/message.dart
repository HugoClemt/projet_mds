import 'package:projet_mds/model/conversation.dart';

class Message {
  final String id;
  final String content;
  final String is_sent_by_human;
  final Conversation conversation_id;

  Message({
    required this.id,
    required this.content,
    required this.is_sent_by_human,
    required this.conversation_id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      is_sent_by_human: json['is_sent_by_human'],
      conversation_id: Conversation.fromJson(json['conversation_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_sent_by_human': is_sent_by_human,
      'conversation_id': conversation_id.toJson(),
    };
  }
}
