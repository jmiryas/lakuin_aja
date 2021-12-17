import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tutorial: https://omadijaya.id/flutter-dynamic-dark-mode-with-provider-and-shared-preferences/

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _preferences;
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  ThemeProvider() {
    _darkMode = true;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _initialPreferences();
    _preferences!.setBool(key, _darkMode);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences!.getBool(key) ?? true;
    notifyListeners();
  }

  toggleChangeTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}
