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
  
  @override
  void initState() {
    super.initState();
    _game = FruitGame(
      onScoreChanged: (score) {
        setState(() {
          _score = score;
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
          child: GameWidget(game: _game),
        );
      },
    );
  }
}
