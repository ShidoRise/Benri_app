import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Calendar shows');
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        width: 40,
        height: 40,
        decoration: const ShapeDecoration(
          color: BColors.white,
          shape: OvalBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(Iconsax.calendar_1),
      ),
    );
  }
}
