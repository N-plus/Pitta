import 'package:flutter/foundation.dart';

import 'body_profile.dart';
import 'clothing_item.dart';
import 'comparison_record.dart';

class AppState extends ChangeNotifier {
  final List<BodyProfile> profiles = [];
  final List<ComparisonRecord> history = [];
  BodyProfile? selectedProfile;

  void addProfile(BodyProfile profile) {
    profiles.add(profile);
    selectedProfile ??= profile;
    notifyListeners();
  }

  void selectProfile(BodyProfile profile) {
    selectedProfile = profile;
    notifyListeners();
  }

  void addComparison(ClothingItem item) {
    final profile = selectedProfile;
    if (profile == null) return;
    history.insert(0, ComparisonRecord(profile: profile, item: item));
    notifyListeners();
  }

  void removeComparison(ComparisonRecord record) {
    history.remove(record);
    notifyListeners();
  }

  void toggleFavorite(ComparisonRecord record) {
    record.isFavorite = !record.isFavorite;
    notifyListeners();
  }

  List<ComparisonRecord> get favorites =>
      history.where((r) => r.isFavorite).toList();
}
