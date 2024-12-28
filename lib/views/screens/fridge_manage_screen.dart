import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/drawer_provider.dart';
import '../widgets/add_drawer.dart';
import '../widgets/drawer_tile.dart';

class FridgeManageScreen extends StatelessWidget {
  const FridgeManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(builder: (context, drawerProvider, child) {
      return Scaffold(
        body: ListView.builder(
          itemCount: drawerProvider.drawers.length,
          itemBuilder: (context, index) {
            return DrawerTile(
              drawerName: drawerProvider.drawers[index],
              deleteFunction: (context) => drawerProvider.removeDrawer(index),
              editFunction: (context) =>
                  drawerProvider.editDrawer(context, index),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fridge_manage_fab',
          onPressed: () async {
            final drawerName =
                await showAddDrawerDialog(context, 'Tạo ngăn tủ mới');
            if (drawerName != null) {
              drawerProvider.addDrawer(drawerName);
            }
          },
          backgroundColor: BColors.primaryFirst,
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
