import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/views/screens/basket_screen.dart';
import 'package:benri_app/views/screens/fridge_screen.dart';
import 'package:benri_app/views/screens/profile_screen.dart';
import 'package:benri_app/views/screens/recipes_sreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/navigation_view_model.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: Consumer<NavigationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 25,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  )
                ],
              ),
              child: NavigationBar(
                backgroundColor: BColors.white,
                indicatorColor: BColors.grey,
                height: 70,
                elevation: 0,
                selectedIndex: viewModel.selectedIndex,
                onDestinationSelected: (index) =>
                    viewModel.setSelectedIndex(index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Iconsax.bag_2),
                    label: 'Basket',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.external_drive),
                    label: 'Fridge',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.reserve),
                    label: 'Recipes',
                  ),
                  NavigationDestination(
                    icon: Icon(Iconsax.user),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: viewModel.selectedIndex,
              children: const [
                BasketScreen(),
                FridgeScreen(),
                RecipesScreen(),
                ProfileScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
