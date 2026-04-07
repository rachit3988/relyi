import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person_profile.dart';

class StorageService {
  static const key = "profiles";

  static Future<void> saveProfiles(List<PersonProfile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final data = profiles.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, data);
  }

  static Future<List<PersonProfile>> getProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((e) => PersonProfile.fromJson(jsonDecode(e))).toList();
  }
}
