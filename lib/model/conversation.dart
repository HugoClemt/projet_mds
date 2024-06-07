import 'package:projet_mds/model/charactere.dart';

class Conversation {
  final String id;
  final String characterId;
  final String userId;
  final Charactere charactere;

  Conversation({
    required this.id,
    required this.characterId,
    required this.userId,
    required this.charactere,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      characterId: json['character_id'],
      userId: json['user_id'],
      charactere: Charactere.fromJson(json['charactere']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character_id': characterId,
      'user_id': userId,
      'charactere': charactere.toJson(),
    };
  }
}
