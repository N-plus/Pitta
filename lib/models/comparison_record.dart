import 'body_profile.dart';
import 'clothing_item.dart';

class ComparisonRecord {
  ComparisonRecord({
    required this.profile,
    required this.item,
  }) {
    shoulderDiff = item.shoulderWidth - profile.shoulderWidth;
    bodyDiff = item.bodyWidth - profile.chest;
    lengthDiff = item.length - profile.height * 0.38; // naive torso length
    sleeveDiff = item.sleeveLength - profile.height * 0.25;
  }

  final BodyProfile profile;
  final ClothingItem item;
  late final double shoulderDiff;
  late final double bodyDiff;
  late final double lengthDiff;
  late final double sleeveDiff;

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
}
