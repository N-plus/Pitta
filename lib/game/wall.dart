import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// 壁・床のボディ
class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final Color color;

  Wall({
    required this.start,
    required this.end,
    this.color = const Color(0xFFFFB6C1),
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2.zero(),
    );

    final body = world.createBody(bodyDef);

    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..friction = 0.5
      ..restitution = 0.1;

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(
      Offset(start.x, start.y),
      Offset(end.x, end.y),
      Paint()
        ..color = color
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }
}

/// ゲームオーバーラインのセンサー
class GameOverLine extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final double y;

  GameOverLine({
    required this.start,
    required this.end,
    required this.y,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2.zero(),
    );

    final body = world.createBody(bodyDef);

    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..isSensor = true;

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    // 点線で描画
    final paint = Paint()
      ..color = Colors.red.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashWidth = 10.0;
    const dashSpace = 8.0;
    double currentX = start.x;
    
    while (currentX < end.x) {
      canvas.drawLine(
        Offset(currentX, y),
        Offset((currentX + dashWidth).clamp(start.x, end.x), y),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }
}
