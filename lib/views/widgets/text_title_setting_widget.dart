import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

Widget textTitleSettingWidget(String title) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 8,
      right: 8,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: BColors.textPrimary),
        ),
        Divider(
          color: BColors.textPrimary.withOpacity(0.4),
        ),
      ],
    ),
  );
}
