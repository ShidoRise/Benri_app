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
    final drawerProvider = Provider.of<DrawerProvider>(context);
    final TextEditingController drawerController = TextEditingController();

    void saveNewDrawer() {
      if (drawerController.text.isNotEmpty) {
        drawerProvider.addDrawer(drawerController.text);
        Navigator.of(context).pop();
        drawerController.clear();
      }
    }

    void addNewDrawer() {
      showDialog(
        context: context,
        builder: (context) {
          return AddDrawer(
            controller: drawerController,
            onSave: saveNewDrawer,
            onCancel: () {
              drawerController.clear();
              Navigator.of(context).pop();
            },
          );
        },
      );
    }

    void deleteNotify(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Bạn có chắc chắn muốn xóa ngăn kéo này không?"),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<DrawerProvider>(context, listen: false)
                      .removeDrawer(index);
                  Navigator.of(context).pop();
                },
                child: const Text("Đồng ý"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Quay lại"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: drawerProvider.drawers.length,
          itemBuilder: (context, index) {
            return DrawerTile(
              drawerName: drawerProvider.drawers[index],
              onDelete: () => deleteNotify(context, index),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: const EdgeInsets.all(5.0),
        child: FloatingActionButton(
          heroTag: 'fridge_manage_fab',
          onPressed: addNewDrawer,
          backgroundColor: BColors.primary,
          child: Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ),
      ),
    );
  }
}
