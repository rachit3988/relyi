import 'package:flutter/material.dart';
import '../models/person_profile.dart';
import '../../../services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  final PersonProfile profile;

  const ChatScreen({super.key, required this.profile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  Map<String, dynamic>? result;
  bool loading = false;

  void askAI() async {
    setState(() => loading = true);

    try {
      final res = await AIService.getAdvice(widget.profile, controller.text);

      setState(() {
        result = res;
      });
    } catch (e) {
      setState(() {
        result = {
          "reaction": "Error: $e",
          "suggested_message": "Check API / Internet",
          "risk": "high",
          "relationship_score": 0
        };
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.profile.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Ask something..."),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: askAI, child: const Text("Get Advice")),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),

            if (result != null) ...[
              Text("Reaction: ${result!['reaction']}"),
              Text("Suggested: ${result!['suggested_message']}"),
              Text("Risk: ${result!['risk']}"),
              Text("Score: ${result!['relationship_score']}"),
            ],
          ],
        ),
      ),
    );
  }
}
