import 'package:flutter_test/flutter_test.dart';

import 'package:pitta/models/body_profile.dart';
import 'package:pitta/models/clothing_item.dart';
import 'package:pitta/models/comparison_record.dart';

void main() {
  test('generates comments based on diff', () {
    final profile = BodyProfile(
      name: 'Me',
      height: 170,
      shoulderWidth: 45,
      chest: 95,
      waist: 80,
      hip: 90,
    );
    final item = ClothingItem(
      name: 'Shirt',
      brand: 'Brand',
      shoulderWidth: 47,
      bodyWidth: 100,
      length: 70,
      sleeveLength: 60,
    );
    final record = ComparisonRecord(profile: profile, item: item);
    expect(record.comments().length, 4);
  });
}
