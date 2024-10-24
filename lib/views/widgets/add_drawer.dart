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
    return AlertDialog(
      title: const Text("Add new drawer"),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
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
                      backgroundColor: BColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 36)),
                  child: const Text("Add"),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                      backgroundColor: BColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 24)),
                  child: const Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
