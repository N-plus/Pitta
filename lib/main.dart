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
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.notoSansJpTextTheme(),
        ),
        home: const HomePage(),
      ),
    );
  }
}
