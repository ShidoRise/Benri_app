import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  UserAvatar({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: BColors.primaryFirst,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '',
        style: TextStyle(color: Colors.white, fontSize: size),
      ),
    );
  }
}
