class ClothingItem {
  ClothingItem({
    required this.name,
    this.brand,
    required this.shoulderWidth,
    required this.bodyWidth,
    required this.length,
    required this.sleeveLength,
  });

  final String name;
  final String? brand;
  final double shoulderWidth;
  final double bodyWidth;
  final double length;
  final double sleeveLength;
}
