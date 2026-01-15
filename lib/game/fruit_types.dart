import 'package:flutter/material.dart';

/// フルーツの種類（小さい順）
enum FruitType {
  cherry,     // さくらんぼ
  grape,      // ぶどう
  orange,     // みかん
  apple,      // りんご
  pear,       // なし
  watermelon, // すいか
  melon,      // メロン（最終）
  devil,      // 悪魔
}

/// フルーツのデータ
class FruitData {
  final FruitType type;
  final String name;
  final String emoji;
  final String imagePath; // 画像パス
  final Color color;
  final Color borderColor;
  final double radius;
  final int points;
  final bool isFinal;
  final FruitType? nextType;

  const FruitData({
    required this.type,
    required this.name,
    required this.emoji,
    required this.imagePath,
    required this.color,
    required this.borderColor,
    required this.radius,
    required this.points,
    this.isFinal = false,
    this.nextType,
  });

  /// 次のフルーツを取得
  FruitData? get next {
    if (nextType != null) {
      return fruitDataMap[nextType];
    }
    return null;
  }
}

/// フルーツデータのマップ
const Map<FruitType, FruitData> fruitDataMap = {
  FruitType.cherry: FruitData(
    type: FruitType.cherry,
    name: 'さくらんぼ',
    emoji: '🍒',
    imagePath: 'assets/images/cherry.png',
    color: Color(0xFFFF4757),
    borderColor: Color(0xFFB33939),
    radius: 15.0,
    points: 1,
    nextType: FruitType.grape,
  ),
  FruitType.grape: FruitData(
    type: FruitType.grape,
    name: 'ぶどう',
    emoji: '🍇',
    imagePath: 'assets/images/grape.png',
    color: Color(0xFF8B5CF6),
    borderColor: Color(0xFF6B21A8),
    radius: 22.0,
    points: 2,
    nextType: FruitType.orange,
  ),
  FruitType.orange: FruitData(
    type: FruitType.orange,
    name: 'みかん',
    emoji: '🍊',
    imagePath: 'assets/images/orange.png',
    color: Color(0xFFFF9F43),
    borderColor: Color(0xFFCC7000),
    radius: 30.0,
    points: 4,
    nextType: FruitType.apple,
  ),
  FruitType.apple: FruitData(
    type: FruitType.apple,
    name: 'りんご',
    emoji: '🍎',
    imagePath: 'assets/images/apple.png',
    color: Color(0xFFEE5A52),
    borderColor: Color(0xFFAA2020),
    radius: 40.0,
    points: 8,
    nextType: FruitType.pear,
  ),
  FruitType.pear: FruitData(
    type: FruitType.pear,
    name: 'なし',
    emoji: '🍐',
    imagePath: 'assets/images/pear.png',
    color: Color(0xFFBADC58),
    borderColor: Color(0xFF7CB305),
    radius: 52.0,
    points: 12,
    nextType: FruitType.watermelon,
  ),
  FruitType.watermelon: FruitData(
    type: FruitType.watermelon,
    name: 'すいか',
    emoji: '🍉',
    imagePath: 'assets/images/watermelon.png',
    color: Color(0xFF2ECC71),
    borderColor: Color(0xFF1D8348),
    radius: 68.0,
    points: 16,
    nextType: FruitType.melon,
  ),
  FruitType.melon: FruitData(
    type: FruitType.melon,
    name: 'メロン',
    emoji: '🍈',
    imagePath: 'assets/images/melon.png',
    color: Color(0xFF55E6C1),
    borderColor: Color(0xFF1ABC9C),
    radius: 85.0,
    points: 20,
    isFinal: true,
    nextType: null,
  ),
  FruitType.devil: FruitData(
    type: FruitType.devil,
    name: '悪魔',
    emoji: '😈',
    imagePath: 'assets/images/devil.png',
    color: Color(0xFFB33939),
    borderColor: Color(0xFF6D214F),
    radius: 34.0,
    points: -3,
    nextType: null,
  ),
};

/// ランダムで落ちてくるフルーツを取得（最初の4種類から）
FruitData getRandomFruit() {
  final randomTypes = [
    FruitType.cherry,
    FruitType.grape,
    FruitType.orange,
    FruitType.apple,
  ];
  final index = DateTime.now().microsecondsSinceEpoch % randomTypes.length;
  return fruitDataMap[randomTypes[index]]!;
}
