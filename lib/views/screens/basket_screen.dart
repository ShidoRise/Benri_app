import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/screens/calendar_screen.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:benri_app/views/widgets/family_basket_view.dart';
import 'package:benri_app/views/widgets/personal_basket_view.dart';
import 'package:flutter/material.dart';
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
                    _calendarIcon(context),
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
