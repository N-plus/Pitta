import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fruit_game.dart';
import 'fruit_types.dart';

/// ドロップ位置のプレビューコンポーネント
class DropPreview extends Component with HasGameReference<FruitGame> {
  DropPreview();
  
  final Map<String, ui.Image> _imageCache = {};

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 画像を事前に読み込む
    await _preloadImages();
  }
  
  Future<void> _preloadImages() async {
    final types = [
      FruitType.cherry,
      FruitType.grape,
      FruitType.orange,
      FruitType.apple,
      FruitType.pear,
      FruitType.watermelon,
      FruitType.melon,
      FruitType.devil,
    ];
    
    for (final type in types) {
      final data = fruitDataMap[type]!;
      await _loadImage(data.imagePath);
    }
  }
  
  Future<void> _loadImage(String path) async {
    if (_imageCache.containsKey(path)) return;
    
    try {
      final imageData = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
      );
      final frame = await codec.getNextFrame();
      _imageCache[path] = frame.image;
    } catch (e) {
      // 画像が見つからない場合は無視
    }
  }

  @override
  void render(Canvas canvas) {
    try {
      if (game.isGameOver || !game.canDrop) return;
      
      final fruit = game.currentFruit;
      if (fruit == null) return;
      
      final x = game.currentDropX;
      final y = 40.0;
      final radius = fruit.radius;
      
      // 画像が読み込まれている場合は画像を描画
      if (_imageCache.containsKey(fruit.imagePath)) {
        final image = _imageCache[fruit.imagePath]!;
        final imageSize = image.width.toDouble();
        final scale = (radius * 2) / imageSize;
        
        canvas.save();
        canvas.translate(x, y);
        canvas.scale(scale);
        canvas.drawImage(
          image,
          Offset(-imageSize / 2, -imageSize / 2),
          Paint()..colorFilter = ColorFilter.mode(
            Colors.white.withValues(alpha: 0.7),
            BlendMode.modulate,
          ),
        );
        canvas.restore();
      } else {
        // フォールバック：半透明の円と絵文字
        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = fruit.color.withValues(alpha: 0.5),
        );
        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()
            ..color = fruit.borderColor.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        
        // 絵文字を中央に描画
        final textSpan = TextSpan(
          text: fruit.emoji,
          style: TextStyle(
            fontSize: radius * 1.2,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      }
      
      // ドロップライン（点線）
      _drawDropLine(canvas, x, y + radius, FruitGame.topMargin - 10, fruit.color);
    } catch (e) {
      // ゲームがまだ初期化されていない、またはエラーが発生した
      return;
    }
  }
  
  void _drawDropLine(Canvas canvas, double x, double startY, double endY, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    const dashLength = 8.0;
    const gapLength = 6.0;
    
    double currentY = startY;
    while (currentY < endY) {
      final nextY = (currentY + dashLength).clamp(startY, endY);
      canvas.drawLine(Offset(x, currentY), Offset(x, nextY), paint);
      currentY = nextY + gapLength;
    }
  }
}
