import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../game/fruit_types.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fruitController;
  
  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _fruitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }
  
  @override
  void dispose() {
    _bounceController.dispose();
    _fruitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F5),
              Color(0xFFFFE4EC),
              Color(0xFFFFF5F7),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 背景のフルーツアニメーション
              ..._buildFloatingFruits(),
              
              // メインコンテンツ
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    
                    // タイトル
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -10 * _bounceController.value),
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          // フルーツアイコン
                          const Text(
                            '🍒 🍇 🍊 🍎',
                            style: TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 16),
                          
                          // ゲームタイトル
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFF6B9D),
                                Color(0xFFFF8E53),
                                Color(0xFFFF6B9D),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'くだもの',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 8,
                                shadows: [
                                  Shadow(
                                    color: Color(0x40000000),
                                    blurRadius: 8,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFF8E53),
                                Color(0xFFFF6B9D),
                                Color(0xFFFF8E53),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'ぽん！',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 12,
                                shadows: [
                                  Shadow(
                                    color: Color(0x40000000),
                                    blurRadius: 8,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          const Text(
                            '🍐 🍉 🍈',
                            style: TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(flex: 1),
                    
                    // 遊び方説明
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B9D).withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'あそびかた',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B9D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildHowToPlayItem('👆', 'ゆびでスライド → いちをきめる'),
                          _buildHowToPlayItem('👇', 'タップ → おとす'),
                          _buildHowToPlayItem('✨', 'おなじくだものをくっつけよう！'),
                        ],
                      ),
                    ),
                    
                    const Spacer(flex: 1),
                    
                    // スタートボタン
                    _buildStartButton(context),
                    
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildFloatingFruits() {
    final fruits = [
      (FruitType.cherry, 0.1, 0.15),
      (FruitType.grape, 0.85, 0.25),
      (FruitType.orange, 0.15, 0.75),
      (FruitType.apple, 0.9, 0.65),
      (FruitType.melon, 0.5, 0.92),
    ];
    
    return fruits.map((fruit) {
      final data = fruitDataMap[fruit.$1]!;
      return AnimatedBuilder(
        animation: _fruitController,
        builder: (context, child) {
          final offset = (_fruitController.value * 2 * 3.14159);
          return Positioned(
            left: MediaQuery.of(context).size.width * fruit.$2 - 20,
            top: MediaQuery.of(context).size.height * fruit.$3 - 20 +
                (10 * (fruit.$2 > 0.5 ? 1 : -1) * (0.5 - (offset % 1))),
            child: Opacity(
              opacity: 0.3,
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          );
        },
      );
    }).toList();
  }
  
  Widget _buildHowToPlayItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GameScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'あそぶ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '🎮',
              style: TextStyle(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
