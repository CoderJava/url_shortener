import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared/shared.dart';

class StorageService {
  static const String _keyHistory = 'link_history';

  Future<void> saveLink(LinkItem link) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getLocalLinks();

    // Prepend new link
    history.insert(0, link);

    // Save as List of Maps -> JSON String
    final List<Map<String, dynamic>> jsonList = history
        .map((e) => e.toJson())
        .toList();

    await prefs.setString(_keyHistory, jsonEncode(jsonList));
  }

  Future<List<LinkItem>> getLocalLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyHistory);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => LinkItem.fromJson(e)).toList();
    } catch (e) {
      // In case of error (corrupt data), clear or return empty
      return [];
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}
