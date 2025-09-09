import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/app_state.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const PittaApp());
}

class PittaApp extends StatelessWidget {
  const PittaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Pitta',
        theme: _buildTheme(),
        home: const HomePage(),
      ),
    );
  }
}

ThemeData _buildTheme() {
  final baseText = GoogleFonts.notoSansJpTextTheme()
      .apply(bodyColor: const Color(0xFF1F2937), displayColor: const Color(0xFF1F2937));
  final body = const Color(0xFF1F2937);
  final support = const Color(0xFF6B7280);
  // Gradient for optional use with primary color styling.
  // ignore: unused_local_variable
  const primaryGradient = LinearGradient(
    colors: [Color(0xFF26D0CE), Color(0xFF1AA2B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFEAF2F1),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF25C5C1),
      onPrimary: Colors.white,
      secondary: Color(0xFFF8C24E),
      onSecondary: Colors.white,
      error: Color(0xFFFF6B6B),
      onError: Colors.white,
      background: Color(0xFFEAF2F1),
      onBackground: Color(0xFF1F2937),
      surface: Colors.white,
      onSurface: Color(0xFF1F2937),
      tertiary: Color(0xFF22C55E),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    textTheme: baseText.copyWith(
      headlineLarge: baseText.headlineLarge?.copyWith(
        color: body,
        height: 1.25,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        color: body,
        height: 1.25,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        color: body,
        height: 1.25,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        color: body,
        height: 1.5,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        color: body,
        height: 1.5,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        color: support,
        height: 1.5,
      ),
    ),
  );
}
