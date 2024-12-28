import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/screens/calendar_screen.dart';
import 'package:benri_app/views/screens/family_members_screen.dart';
import 'package:benri_app/views/widgets/add_family_ingredient_dialog.dart';
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
    return Consumer2<BasketViewModel, ProfileViewModel>(
        builder: (context, basketViewModel, profileViewModel, child) {
      return Scaffold(
        appBar: const BAppBar(title: 'My Basket'),
        body: Consumer2<BasketViewModel, ProfileViewModel>(
          builder: (context, basketViewModel, profileViewModel, child) {
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
                        : (profileViewModel.isLoggedIn &&
                                basketViewModel.hasInternet &&
                                basketViewModel.hasFamily)
                            ? Row(
                                children: [
                                  _memberListIcon(context),
                                  _shareButton(context, basketViewModel),
                                ],
                              )
                            : Container(),
                  ],
                ),
                Expanded(
                  child: basketViewModel.selectedMode == 'Cá nhân'
                      ? PersonalBasketView()
                      : FamilyBasketView(),
                ),
              ],
            );
          },
        ),
        floatingActionButton: (basketViewModel.selectedMode == 'Cá nhân' ||
                (basketViewModel.selectedMode == 'Gia đình' &&
                    profileViewModel.isLoggedIn &&
                    basketViewModel.hasInternet &&
                    basketViewModel.hasFamily))
            ? _floatingButton(context)
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
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Iconsax.calendar_1),
      ),
    );
  }

  Widget _shareButton(BuildContext context, BasketViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          builder: (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Family'),
                          content: const Text(
                              'Are you sure you want to delete this family?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await viewModel.deleteFamily();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Family deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error deleting family: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text("Delete Family",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Share Family Code',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            viewModel.familyCode ?? 'No code available',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            if (viewModel.familyCode != null) {
                              await Clipboard.setData(
                                ClipboardData(text: viewModel.familyCode!),
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Code copied to clipboard'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
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
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Iconsax.link),
      ),
    );
  }

  Widget _memberListIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FamilyMembersScreen(),
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
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Iconsax.tag_user),
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final basketViewModel =
            Provider.of<BasketViewModel>(context, listen: false);
        basketViewModel.resetSelections();

        final ingredient = await (basketViewModel.selectedMode == 'Cá nhân'
            ? addIngredientDialog(context)
            : addFamilyIngredientDialog(context));

        if (ingredient != null && context.mounted) {
          if (basketViewModel.selectedMode == 'Cá nhân') {
            basketViewModel.addIngredient(ingredient as BasketIngredient);
          } else {
            basketViewModel.addFamilyIngredient(ingredient as FamilyIngredient);
          }
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
