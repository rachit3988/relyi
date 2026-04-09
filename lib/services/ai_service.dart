import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person_profile.dart';
import '../utils/prompt_builder.dart';

class AIService {

  static Future<Map<String, dynamic>> getAdvice(
      PersonProfile profile,
      String question,
      ) async {
    final prompt = buildPrompt(profile, question);

    final response = await http.post(
      Uri.parse("https://relyi-go-backend.onrender.com/ai"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "prompt": prompt,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      String content;

      if (data is Map<String, dynamic> && data.containsKey('reaction')) {
        return data;
      } else if (data is Map<String, dynamic> && data.containsKey('choices')) {
        content = data["choices"][0]["message"]["content"];
      } else {
        throw Exception("Unknown API response format: ${response.body}");
      }

      content = content.trim();

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      try {
        return jsonDecode(content);
      } catch (e) {
        final jsonStart = content.indexOf("{");
        final jsonEnd = content.lastIndexOf("}");

        if (jsonStart != -1 && jsonEnd != -1) {
          final cleanJson = content.substring(jsonStart, jsonEnd + 1);
          return jsonDecode(cleanJson);
        }

        return {
          "reaction": content,
          "suggested_message": "Try rephrasing",
          "risk": "neutral",
          "relationship_score": 50,
        };
      }
    } else {
      throw Exception("Groq API Error: ${response.body}");
    }
  }
}