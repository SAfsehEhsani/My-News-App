// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key for storing the theme preference in SharedPreferences
const String _themeModeKey = 'themeMode';

class ThemeProvider with ChangeNotifier {
  // Default theme mode is system
  ThemeMode _themeMode = ThemeMode.system;

  // Getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Constructor: Load theme preference when the provider is created
  ThemeProvider() {
    _loadThemeMode();
  }

  // Load the saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Read the saved string, default to 'system' if not found
    final savedTheme = prefs.getString(_themeModeKey) ?? 'system';
    // Convert the string back to ThemeMode enum
    _themeMode = _themeModeFromString(savedTheme);
    notifyListeners(); // Notify listeners after loading the initial theme
  }

  // Set the new theme mode and save it to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode; // Update the internal state
      notifyListeners(); // Notify listeners (MyApp will rebuild)

      // Save the new theme mode to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeModeToString(mode));
    }
  }

  // Helper function to convert ThemeMode enum to String
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  // Helper function to convert String back to ThemeMode enum
  ThemeMode _themeModeFromString(String modeString) {
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default: // Default to system if string is unknown
        return ThemeMode.system;
    }
  }

  // Optional: Toggle between light and dark (excluding system for simplicity)
  // void toggleTheme() {
  //    if (_themeMode == ThemeMode.light) {
  //        setThemeMode(ThemeMode.dark);
  //    } else {
  //        setThemeMode(ThemeMode.light);
  //    }
  // }
}