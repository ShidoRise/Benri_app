import 'package:benri_app/views/widgets/family_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';

class FamilyBasketView extends StatelessWidget {
  final BasketViewModel basketViewModel;

  const FamilyBasketView({
    super.key,
    required this.basketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.family_restroom,
          size: 64,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        const Text(
          'Family Mode Coming Soon',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => const FamilyOptionsSheet(),
            );
          },
          child: const Text('Set up Family'),
        ),
      ],
    );
  }
}
