import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

Widget textTitleSettingWidget(String title, BuildContext context) {
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
              color: Theme.of(context).colorScheme.secondaryFixed),
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ],
    ),
  );
}
