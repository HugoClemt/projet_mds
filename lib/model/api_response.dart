class ApiResponse {
  final bool success;
  final String message;
  final String? token;
  final String? id;
  final dynamic? data;

  ApiResponse(
      {required this.success,
      required this.message,
      this.token,
      this.id,
      this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      token: json['token'],
      id: json['id'],
      data: json['data'] ?? null,
    );
  }
}
