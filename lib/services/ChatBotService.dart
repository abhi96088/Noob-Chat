import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotService {
  final String apiKey = "AIzaSyA5gzpNF2FXLctNhSWfEcvk6peK4TBOvyU";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=AIzaSyA5gzpNF2FXLctNhSWfEcvk6peK4TBOvyU";


  Future<String> sendMessage(String message) async {
    var data = {
      "contents": [
        {
          "parts": [
            {"text": message}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extracting response text correctly
        if (responseData.containsKey("candidates")) {
          return responseData["candidates"][0]["content"]["parts"][0]["text"];
        } else {
          return "Error: Invalid response from API";
        }
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
