import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/themes/custom_pastel_mode.dart';
import 'package:dress_app/themes/dark_mode.dart';
import 'package:dress_app/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

enum ThemeType {
  light,
  dark,
  customPastel,
}

class ThemeProvider extends ChangeNotifier {
  // Default theme
  ThemeData _themeData = lightMode;
  ThemeType _themeType = ThemeType.light;

  // Custom theme colors
  Color _primaryColor = ColorTokens.rosePetal;
  Color _secondaryColor = ColorTokens.lavenderMist;
  Color _accentColor = ColorTokens.mintFoam;

  // Storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Constructor
  ThemeProvider() {
    _loadThemePreferences();
  }

  // Getters
  ThemeData get themeData => _themeData;
  ThemeType get themeType => _themeType;
  bool get isDarkMode => _themeType == ThemeType.dark;
  bool get isCustomTheme => _themeType == ThemeType.customPastel;

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get accentColor => _accentColor;

  // Setters
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Theme switching methods
  void setLightTheme() {
    _themeType = ThemeType.light;
    _themeData = lightMode;
    _saveThemePreferences();
    notifyListeners();
  }

  void setDarkTheme() {
    _themeType = ThemeType.dark;
    _themeData = darkMode;
    _saveThemePreferences();
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeType == ThemeType.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  // Custom theme methods
  void setCustomPastelTheme({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
  }) {
    if (primaryColor != null) _primaryColor = primaryColor;
    if (secondaryColor != null) _secondaryColor = secondaryColor;
    if (accentColor != null) _accentColor = accentColor;

    _themeType = ThemeType.customPastel;
    _themeData = createCustomPastelTheme(
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      accentColor: _accentColor,
      isDarkMode: false, // Custom pastel is always light mode based
    );

    _saveThemePreferences();
    notifyListeners();
  }

  // Accessibility support
  void applyHighContrastIfNeeded(bool isHighContrastEnabled) {
    if (isHighContrastEnabled) {
      // Apply high contrast adjustments
      if (_themeType == ThemeType.customPastel) {
        // Recreate custom theme with high contrast
        _themeData = createCustomPastelTheme(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          isDarkMode: false,
        );
      }
      notifyListeners();
    }
  }

  // Persistence methods
  Future<void> _saveThemePreferences() async {
    try {
      // Save theme type
      await _storage.write(key: 'theme_type', value: _themeType.toString());

      // Save custom colors if using custom theme
      if (_themeType == ThemeType.customPastel) {
        final Map<String, String> colorData = {
          'primary': _primaryColor.value.toString(),
          'secondary': _secondaryColor.value.toString(),
          'accent': _accentColor.value.toString(),
        };
        await _storage.write(key: 'theme_colors', value: jsonEncode(colorData));
      }
    } catch (e) {
      // Error saving theme preferences - continue silently
    }
  }

  Future<void> _loadThemePreferences() async {
    try {
      // Load theme type
      final themeTypeStr = await _storage.read(key: 'theme_type');
      if (themeTypeStr != null) {
        if (themeTypeStr == ThemeType.dark.toString()) {
          _themeType = ThemeType.dark;
          _themeData = darkMode;
        } else if (themeTypeStr == ThemeType.customPastel.toString()) {
          _themeType = ThemeType.customPastel;

          // Load custom colors
          final colorsJson = await _storage.read(key: 'theme_colors');
          if (colorsJson != null) {
            final Map<String, dynamic> colorData = jsonDecode(colorsJson);
            _primaryColor = Color(int.parse(colorData['primary']));
            _secondaryColor = Color(int.parse(colorData['secondary']));
            _accentColor = Color(int.parse(colorData['accent']));
          }

          // Create custom theme
          _themeData = createCustomPastelTheme(
            primaryColor: _primaryColor,
            secondaryColor: _secondaryColor,
            accentColor: _accentColor,
            isDarkMode: false,
          );
        } else {
          _themeType = ThemeType.light;
          _themeData = lightMode;
        }
      }
    } catch (e) {
      // Error loading theme preferences - use defaults
      // Default to light theme if there's an error
      _themeType = ThemeType.light;
      _themeData = lightMode;
    }

    // Notify listeners after loading preferences
    notifyListeners();
  }
}
