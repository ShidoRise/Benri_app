import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController searchController;

  const MySearchBar({
    super.key,
    required this.hintText,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
