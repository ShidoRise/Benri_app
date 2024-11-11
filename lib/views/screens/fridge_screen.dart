import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/colors.dart';
import '../../view_models/fridge_screen_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/my_search_bar.dart';
import 'detail_fridge_screen.dart';
import 'fridge_manage_screen.dart';

class FridgeScreen extends StatelessWidget {
  const FridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the provider when building the widget
    final fridgeProvider =
        Provider.of<FridgeScreenProvider>(context, listen: false);

    fridgeProvider.initialize(context);

    return Scaffold(
      appBar: BAppBar(
        title: 'My Fridge',
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar for searching ingredients
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MySearchBar(
                hintText: 'Search Your Ingredient',
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<FridgeScreenProvider>(
                builder: (context, provider, child) {
                  return TabBar(
                    controller: provider
                        .tabController, // Use TabController from provider
                    labelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: BColors.black),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    indicatorColor: Colors.black,
                    indicatorWeight: 3.0,
                    tabs: const [
                      Tab(
                        text: 'Fridge',
                      ),
                      Tab(
                        text: 'Detail',
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<FridgeScreenProvider>(
                builder: (context, provider, child) {
                  return TabBarView(
                    controller: provider
                        .tabController, // Use TabController from provider
                    children: const [
                      FridgeManageScreen(),
                      DetailFridgeScreen(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
