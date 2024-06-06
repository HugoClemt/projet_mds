import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projet_mds/service/authentification_service.dart';

class CharactereService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllCharactereInfo(
      String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllCharactere: ${response.statusCode}');
    print('Response body getAllCharactere: ${response.body}');

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
}
