import 'package:flutter/material.dart';

class AppColour {
  static const Color primaryAccent = Color(0xFF1B52E8);
  static const Color darkBackground1 = Color(0xFFFFFFFF); // Pure White
  static const Color darkBackground2 = Color(0xFFF8FAFC); // Light Gray-Blue
  static const Color secondaryAccent = Color(0xFF3B66F6);

  // General colors (adapted for light theme contrast)
  static const Color white = Color(0xFF0F172A); // Slate 900 (Main text)
  static const Color white70 = Color(0xFF475569); // Slate 600 (Muted text)
  static const Color white38 = Color(0xFF94A3B8); // Slate 400 (Hint/Border)
  static const Color redAccent = Colors.redAccent;
  static const Color black = Colors.white; // Flipped to support light theme cards/dialogs
}