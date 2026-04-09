import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/person_profile.dart';
import '../../../services/storage_service.dart';
import 'chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<PersonProfile> profiles = [];

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  void loadProfiles() async {
    profiles = await StorageService.getProfiles();
    setState(() {});
  }

  void addProfile(PersonProfile p) async {
    profiles.add(p);
    await StorageService.saveProfiles(profiles);
    setState(() {});
  }

  Future<void> _launchPrivacyPolicy() async {
    final Uri url = Uri.parse('https://rachit3988.github.io/relyi/privacy-policy.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void showAddDialog() {
    final name = TextEditingController();
    final personality = TextEditingController();
    final relationship = TextEditingController();
    final notes = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Person"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: personality,
                decoration: const InputDecoration(labelText: "Personality"),
              ),
              TextField(
                controller: relationship,
                decoration: const InputDecoration(labelText: "Relationship"),
              ),
              TextField(
                controller: notes,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addProfile(
                PersonProfile(
                  name: name.text,
                  personality: personality.text,
                  relationship: relationship.text,
                  notes: notes.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profiles"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'privacy') {
                _launchPrivacyPolicy();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'privacy',
                  child: Text('Privacy Policy'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (_, i) {
          final p = profiles[i];
          return ListTile(
            title: Text(p.name),
            subtitle: Text("${p.relationship} • ${p.personality}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(profile: p)),
              );
            },
          );
        },
      ),
    );
  }
}
