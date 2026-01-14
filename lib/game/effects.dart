import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 「ぽん！」エフェクト
class PopEffect extends PositionComponent {
  final String text;
  final Color color;
  double _elapsed = 0;
  static const duration = 0.8;
  
  PopEffect({
    required Vector2 position,
    this.text = 'ぽん！',
    this.color = const Color(0xFFFF6B9D),
  }) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _elapsed / duration;
    final alpha = (1 - progress).clamp(0.0, 1.0);
    final scale = 1.0 + progress * 0.5;
    final yOffset = -progress * 50;

    canvas.save();
    canvas.translate(0, yOffset);
    canvas.scale(scale, scale);

    // テキスト描画
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color.withValues(alpha: alpha),
        shadows: [
          Shadow(
            color: Colors.white.withValues(alpha: alpha),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }
}

/// キラキラエフェクト
class SparkleEffect extends PositionComponent {
  final Color color;
  final int particleCount;
  final List<_Particle> _particles = [];
  double _elapsed = 0;
  static const duration = 1.0;
  
  SparkleEffect({
    required Vector2 position,
    this.color = const Color(0xFFFFD700),
    this.particleCount = 12,
  }) : super(position: position) {
    final random = Random();
    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi * i) / particleCount + random.nextDouble() * 0.5;
      final speed = 80 + random.nextDouble() * 60;
      _particles.add(_Particle(
        angle: angle,
        speed: speed,
        size: 4 + random.nextDouble() * 4,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _elapsed / duration;
    final alpha = (1 - progress).clamp(0.0, 1.0);

    for (final particle in _particles) {
      final distance = particle.speed * progress;
      final x = cos(particle.angle) * distance;
      final y = sin(particle.angle) * distance;
      final size = particle.size * (1 - progress * 0.5);

      // 星形を描画
      _drawStar(canvas, Offset(x, y), size, color.withValues(alpha: alpha));
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final path = Path();
    const points = 4;
    final innerRadius = size * 0.4;
    final outerRadius = size;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (pi / 2) + (pi * i) / points;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = color);
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;

  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
  });
}

/// スコアポップアップエフェクト
class ScorePopup extends PositionComponent {
  final int points;
  double _elapsed = 0;
  static const duration = 1.2;
  
  ScorePopup({
    required Vector2 position,
    required this.points,
  }) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _elapsed / duration;
    final alpha = (1 - progress).clamp(0.0, 1.0);
    final yOffset = -progress * 80;

    final textSpan = TextSpan(
      text: '+$points',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFF6B9D).withValues(alpha: alpha),
        shadows: [
          Shadow(
            color: Colors.white.withValues(alpha: alpha),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
          Shadow(
            color: Colors.black.withValues(alpha: alpha * 0.3),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, yOffset - textPainter.height / 2),
    );
  }
}
