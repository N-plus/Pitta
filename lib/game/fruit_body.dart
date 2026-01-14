import 'dart:ui' as ui;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fruit_types.dart';
import 'fruit_game.dart';

/// フルーツの物理ボディ
class FruitBody extends BodyComponent<FruitGame> with ContactCallbacks {
  final FruitData fruitData;
  final Vector2 initialPosition;
  bool isMarkedForMerge = false;
  bool hasSettled = false;
  ui.Image? _fruitImage;
  bool _imageLoaded = false;
  
  FruitBody({
    required this.fruitData,
    required this.initialPosition,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 画像を読み込む
    await _loadImage();
  }
  
  Future<void> _loadImage() async {
    try {
      final imageData = await rootBundle.load(fruitData.imagePath);
      final codec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
      );
      final frame = await codec.getNextFrame();
      _fruitImage = frame.image;
      _imageLoaded = true;
    } catch (e) {
      // 画像が見つからない場合はフォールバック
      _imageLoaded = false;
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = fruitData.radius / game.worldScale;

    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.2;

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    final screenRadius = fruitData.radius;
    
    // 影
    canvas.drawCircle(
      Offset(2, 3),
      screenRadius,
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );
    
    // 画像が読み込まれている場合は画像を描画
    if (_imageLoaded && _fruitImage != null) {
      final imageSize = _fruitImage!.width.toDouble();
      final scale = (screenRadius * 2) / imageSize;
      
      canvas.save();
      canvas.scale(scale);
      canvas.drawImage(
        _fruitImage!,
        Offset(-imageSize / 2, -imageSize / 2),
        Paint(),
      );
      canvas.restore();
      
      // 縁取り
      canvas.drawCircle(
        Offset.zero,
        screenRadius,
        Paint()
          ..color = fruitData.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    } else {
      // フォールバック：色付き円と絵文字
      // 本体
      canvas.drawCircle(
        Offset.zero,
        screenRadius,
        Paint()..color = fruitData.color,
      );
      
      // 縁取り
      canvas.drawCircle(
        Offset.zero,
        screenRadius,
        Paint()
          ..color = fruitData.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      
      // 絵文字を中央に描画
      final textSpan = TextSpan(
        text: fruitData.emoji,
        style: TextStyle(
          fontSize: screenRadius * 1.2,
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
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is FruitBody && 
        other.fruitData.type == fruitData.type &&
        !isMarkedForMerge &&
        !other.isMarkedForMerge) {
      // 同じフルーツとの衝突
      game.scheduleMerge(this, other);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // 落ち着いたかどうかをチェック
    if (!hasSettled && body.linearVelocity.length < 0.5) {
      hasSettled = true;
    }
  }
}
