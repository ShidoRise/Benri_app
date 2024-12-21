// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class AddDrawer extends StatelessWidget {
  final TextEditingController controller;

  VoidCallback onSave;

  VoidCallback onCancel;

  AddDrawer(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        "Add new drawer",
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onSave,
                  style: TextButton.styleFrom(
                      backgroundColor:
                          isDark ? const Color(0xFF3A3A3A) : BColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: Text(
                    "Thêm",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isDark ? const Color(0xFF3A3A3A) : BColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Huỷ bỏ",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
