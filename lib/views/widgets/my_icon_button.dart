import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback pressed;
  const MyIconButton({super.key, required this.icon, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          fixedSize: const Size(50, 50),
          backgroundColor: Colors.white),
    );
  }
}
