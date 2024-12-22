import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/family_options_sheet.dart';

class BasketModeToggle extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const BasketModeToggle({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: BColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: basketViewModel.selectedMode,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: BColors.primary),
          style: const TextStyle(
            color: BColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            DropdownMenuItem(
              value: 'Cá nhân',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: BColors.primaryFirst, size: 20),
                  SizedBox(width: 8),
                  Text('Cá nhân'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'Gia đình',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.family_restroom,
                      color: BColors.primaryFirst, size: 20),
                  SizedBox(width: 8),
                  Text('Gia đình'),
                ],
              ),
            ),
          ],
          onChanged: (String? newValue) {
            if (newValue == 'Gia đình' && !basketViewModel.hasFamily) {
              showModalBottomSheet(
                context: context,
                builder: (context) => const FamilyOptionsSheet(),
              );
            } else {
              basketViewModel.changeMode(newValue!);
            }
          },
        ),
      ),
    );
  }
}
