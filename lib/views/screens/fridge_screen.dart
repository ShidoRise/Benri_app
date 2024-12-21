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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BAppBar(
          title: 'Tủ Lạnh',
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<FridgeScreenProvider>(
                builder: (context, provider, child) {
                  return TabBar(
                    onTap: provider.changeTab,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                    ),
                    indicatorWeight: 3.0,
                    tabs: const [
                      Tab(
                        text: 'Tủ lạnh',
                        height: 62,
                      ),
                      Tab(
                        text: 'Thực phẩm',
                        height: 62,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: const [
                    FridgeManageScreen(),
                    DetailFridgeScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
