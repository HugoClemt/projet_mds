class SendMessageResponse {
  final Map<String, dynamic> message;
  final Map<String, dynamic> answer;

  SendMessageResponse({
    required this.message,
    required this.answer,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'] as Map<String, dynamic>,
      answer: json['answer'] as Map<String, dynamic>,
    );
  }
}
