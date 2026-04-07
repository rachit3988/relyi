import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person_profile.dart';
import '../utils/prompt_builder.dart';

class AIService {
  static const String apiKey = "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";

  static Future<Map<String, dynamic>> getAdvice(
      PersonProfile profile,
      String question,
      ) async {
    final prompt = buildPrompt(profile, question);

    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "system",
            "content":
            "You MUST always return valid JSON only. No extra text."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String content = data["choices"][0]["message"]["content"];

      // 🔥 CLEAN RESPONSE (important for Groq sometimes)
      content = content.trim();

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      try {
        return jsonDecode(content);
      } catch (e) {
        // fallback parsing if model adds text
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