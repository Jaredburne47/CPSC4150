import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quick_note.dart';

// Handles saving and loading notes using shared_preferences
class NoteStorage {
  static const String _key = 'quicknotes_v1';

  // Load the notes list from shared_preferences
  Future<List<QuickNote>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    // If nothing stored yet, return an empty list
    if (raw == null || raw.trim().isEmpty) return <QuickNote>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((m) => QuickNote.fromJson(m))
            .toList();
      }
      // If structure isn't a list, treat as invalid
      return <QuickNote>[];
    } catch (_) {
      // If data is corrupted, reset storage
      await prefs.remove(_key);
      return <QuickNote>[];
    }
  }

  // Save the current list of notes as a JSON string
  Future<void> save(List<QuickNote> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final list = notes.map((n) => n.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  // Clear all saved notes
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}