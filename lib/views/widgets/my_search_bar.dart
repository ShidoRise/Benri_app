import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;
  const MySearchBar({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          // Border when the TextField is enabled
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey, // Set the border color when enabled
              width: 1.5, // Set the width of the border
            ),
          ),
          // Border when the TextField is focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black, // Set the border color when focused
              width: 2.0, // Set the width of the border when focused
            ),
          ),
        ),
      ),
    );
  }
}
