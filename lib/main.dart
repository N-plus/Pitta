import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 縦画面固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const KudamonoponApp());
}

class KudamonoponApp extends StatelessWidget {
  const KudamonoponApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'くだもの ぽん！',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
