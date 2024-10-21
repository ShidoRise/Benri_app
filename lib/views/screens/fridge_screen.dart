import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/colors.dart';
import '../../view_models/fridge_screen_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/my_search_bar.dart';
import 'detail_fridge_screen.dart';
import 'fridge_manage_screen.dart';
// Import the provider

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Initialize the FridgeScreenProvider
    Provider.of<FridgeScreenProvider>(context, listen: false).initialize(this);
  }

  @override
  void dispose() {
    // Dispose the controllers using the provider
    Provider.of<FridgeScreenProvider>(context, listen: false)
        .disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fridgeProvider = Provider.of<FridgeScreenProvider>(context);

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
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: MySearchBar(
                hintText: 'Search Your Ingredient',
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(
                controller: fridgeProvider
                    .tabController, // Use TabController from provider
                labelColor: Colors.black,
                unselectedLabelColor: BColors.black,
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
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: fridgeProvider
                    .tabController, // Use TabController from provider
                children: const [
                  FridgeManageScreen(),
                  DetailFridgeScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
