import 'package:benri_app/models/families/family_members.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/services/family_service.dart';

class FamilyViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FamilyMember> get members => FamilyService.familyMembers;

  Future<void> loadFamilyMembers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final familyId = await FamilyService.storage.read(key: 'familyId');
      print('Family ID: $familyId');
      if (familyId != null) {
        await FamilyService.getFamily(familyId);
      }
    } catch (e) {
      print('Error loading family members: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
