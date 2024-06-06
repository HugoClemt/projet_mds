import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projet_mds/model/api_response.dart';
import 'package:projet_mds/service/authentification_service.dart';

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllConversation() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllConversation: ${response.statusCode}');
    print('Response body getAllConversation: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all conversation: ${response.body}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllUniverse() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status getAllUniverse: ${response.statusCode}');
    //print('Response body getAllUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all universe: ${response.body}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCharactersByUniverse(
      String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status getCharactersByUniverse: ${response.statusCode}');
    //print('Response body getCharactersByUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all user info: ${response.body}');
      return [];
    }
  }

  Future<ApiResponse> createConversation(String charactereID) async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    final String? userId = await AuthentificationService().getId();

    final data = {'character_id': charactereID, 'user_id': userId};
    final String jsonBody = jsonEncode(data);

    print('Request body: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status createConversation: ${response.statusCode}');
    print('Response body createConversation: ${response.body}');

    if (response.statusCode == 201) {
      return ApiResponse(success: true, message: 'Conversation created');
    } else {
      return ApiResponse(
          success: false, message: 'Failed to create conversation');
    }
  }
}
