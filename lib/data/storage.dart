import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppStorage {
  Future<Map<String, dynamic>> read();
  Future<void> write(Map<String, dynamic> data);
}

class PreferencesStorage implements AppStorage {
  PreferencesStorage({this.key = 'ardent_state_v1'});
  final _preferences = SharedPreferencesAsync();
  final String key;
  @override
  Future<Map<String, dynamic>> read() async {
    final raw = await _preferences.getString(key);
    if (raw == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  @override
  Future<void> write(Map<String, dynamic> data) =>
      _preferences.setString(key, jsonEncode(data));
}
