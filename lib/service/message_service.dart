import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projet_mds/model/api_response.dart';
import 'package:projet_mds/model/send_message_response.dart';
import 'package:projet_mds/service/authentification_service.dart';

class MessageService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<ApiResponse> sendMessage(String content, String conversationId) async {
    final token = await AuthentificationService().getToken();
    final data = {'content': content};
    final jsonBody = jsonEncode(data);

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status sendMessage: ${response.statusCode}');
    print('Response body sendMessage: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse(
        success: true,
        message: 'Message sent successfully',
        token: null,
        id: null,
        data: SendMessageResponse.fromJson(jsonResponse),
      );
    } else {
      return ApiResponse(success: false, message: response.body);
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getMessages: ${response.statusCode}');
    print('Response body getMessages: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load messages: ${response.body}');
      return [];
    }
  }
}
