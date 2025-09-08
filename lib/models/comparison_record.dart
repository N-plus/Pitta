import 'body_profile.dart';
import 'clothing_item.dart';

class ComparisonRecord {
  ComparisonRecord({
    required this.profile,
    required this.item,
    DateTime? compareDate,
    this.isFavorite = false,
  }) {
    shoulderDiff = item.shoulderWidth - profile.shoulderWidth;
    bodyDiff = item.bodyWidth - profile.chest;
    lengthDiff = item.length - profile.height * 0.38; // naive torso length
    sleeveDiff = item.sleeveLength - profile.height * 0.25;
    this.compareDate = compareDate ?? DateTime.now();
  }

  final BodyProfile profile;
  final ClothingItem item;
  late final double shoulderDiff;
  late final double bodyDiff;
  late final double lengthDiff;
  late final double sleeveDiff;

  bool isFavorite;
  late final DateTime compareDate;

  String commentFor(double diff, String part) {
    if (diff.abs() < 1) return '$part is just right';
    if (diff > 0) return '$part is a bit loose (+${diff.toStringAsFixed(1)}cm)';
    return '$part is a bit tight (${diff.toStringAsFixed(1)}cm)';
  }

  List<String> comments() => [
        commentFor(shoulderDiff, 'Shoulder'),
        commentFor(bodyDiff, 'Body width'),
        commentFor(lengthDiff, 'Length'),
        commentFor(sleeveDiff, 'Sleeve'),
      ];

  Map<String, double> sizeDiffs() => {
        '肩幅': shoulderDiff,
        '身幅': bodyDiff,
        '着丈': lengthDiff,
        '袖丈': sleeveDiff,
      };

  String overallFit() {
    final diffs = [shoulderDiff, bodyDiff, lengthDiff, sleeveDiff];
    final maxAbs = diffs.map((d) => d.abs()).reduce((a, b) => a > b ? a : b);
    final avg = diffs.reduce((a, b) => a + b) / diffs.length;
    if (maxAbs < 1) return 'ちょうど良い';
    return avg > 0 ? '少し大きめ' : '小さすぎ';
  }
}
