import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class BAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const BAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 10,
            offset: Offset(0, 1),
            spreadRadius: 1,
          )
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: BColors.accent,
      ),
    );
  }
}
