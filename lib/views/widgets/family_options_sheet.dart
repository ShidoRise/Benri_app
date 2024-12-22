import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class FamilyOptionsSheet extends StatelessWidget {
  const FamilyOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final basketViewModel =
        Provider.of<BasketViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.create, color: BColors.primary),
            title: const Text('Create Family'),
            onTap: () {
              basketViewModel.changeMode('Gia đình');
              Navigator.pop(context);
              // TODO: Navigate to create family screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add, color: BColors.primary),
            title: const Text('Join Family'),
            onTap: () {
              basketViewModel.changeMode('Gia đình');
              Navigator.pop(context);
              // TODO: Navigate to join family screen
            },
          ),
        ],
      ),
    );
  }
}
