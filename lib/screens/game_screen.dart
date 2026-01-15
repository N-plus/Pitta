import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/fruit_game.dart';
import 'game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FruitGame _game;
  int _score = 0;
  int _bestScore = 0;
  
  @override
  void initState() {
    super.initState();
    _game = FruitGame(
      onScoreChanged: (score) {
        setState(() {
          _score = score;
          if (_score > _bestScore) {
            _bestScore = _score;
          }
        });
      },
      onGameOver: _showGameOver,
    );
  }
  
  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: _score,
        onRetry: () {
          Navigator.of(context).pop();
          setState(() {
            _score = 0;
          });
          _game.resetGame();
        },
        onHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildGameArea(),
      ),
    );
  }
  
  Widget _buildGameArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _game.updateGameSize(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              GameWidget(game: _game),
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: _buildScoreHeader(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildScoreLabel('スコア', _score),
          _buildScoreLabel('最高得点', _bestScore),
        ],
      ),
    );
  }

  Widget _buildScoreLabel(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6D6D6D),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
