import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ElevatedButtonStyle {
  static ButtonStyle primary({bool isLoading = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isLoading ? Colors.grey : BColors.primary,
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
