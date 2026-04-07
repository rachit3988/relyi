import '../models/person_profile.dart';

String buildPrompt(PersonProfile p, String question) {
  return """
You are an AI relationship advisor.

Person Details:
Name: ${p.name}
Personality: ${p.personality}
Relationship: ${p.relationship}
Context: ${p.notes}

User Question:
$question

Respond strictly in JSON:

{
  "reaction": "...",
  "suggested_message": "...",
  "risk": "low | neutral | high",
  "relationship_score": number (0-100)
}
""";
}
