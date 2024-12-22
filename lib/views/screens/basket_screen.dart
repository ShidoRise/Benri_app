import 'package:benri_app/services/family_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/screens/calendar_screen.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:benri_app/views/widgets/family_basket_view.dart';
import 'package:benri_app/views/widgets/personal_basket_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/basket_mode_toggle.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BasketViewModel>(
        builder: (context, basketViewModel, child) {
      return Scaffold(
        appBar: const BAppBar(title: 'My Basket'),
        body: Consumer<BasketViewModel>(
          builder: (context, basketViewModel, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child:
                            BasketModeToggle(basketViewModel: basketViewModel)),
                    basketViewModel.selectedMode == 'Cá nhân'
                        ? _calendarIcon(context)
                        : _shareButton(context, basketViewModel),
                  ],
                ),
                Expanded(
                  child: basketViewModel.selectedMode == 'Cá nhân'
                      ? PersonalBasketView(basketViewModel: basketViewModel)
                      : FamilyBasketView(basketViewModel: basketViewModel),
                ),
              ],
            );
          },
        ),
        floatingActionButton: basketViewModel.selectedMode == 'Cá nhân'
            ? _basketFloatingButton(context)
            : null,
      );
    });
  }

  Widget _calendarIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CalendarScreen(),
          ),
        );
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
            ),
          ],
        ),
        child: const Icon(Iconsax.calendar_1),
      ),
    );
  }

  Widget _shareButton(BuildContext context, BasketViewModel viewModel) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Family Code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        viewModel.familyCode ?? 'No code available',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          if (viewModel.familyCode != null) {
                            await Clipboard.setData(
                              ClipboardData(text: viewModel.familyCode!),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _basketFloatingButton(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      margin: const EdgeInsets.all(5.0),
      child: FloatingActionButton(
        backgroundColor: BColors.primaryFirst,
        onPressed: () async {
          final basketViewModel = context.read<BasketViewModel>();
          final ingredient = await addIngredientDialog(context);
          if (ingredient != null && ingredient.name != "") {
            basketViewModel.addIngredient(ingredient);
          }
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}
