class Conversation {
  final String id;
  final String characterId;
  final String userId;

  Conversation({
    required this.id,
    required this.characterId,
    required this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      characterId: json['character_id'],
      userId: json['user_id'],
    );
  }
}
