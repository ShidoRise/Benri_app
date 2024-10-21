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

    // Save the new drawer via DrawerProvider
    void saveNewDrawer() {
      if (drawerController.text.isNotEmpty) {
        drawerProvider.addDrawer(drawerController.text);
        Navigator.of(context).pop();
      }
    }

    // Function to show the dialog to add a new drawer
    void addNewDrawer() {
      showDialog(
        context: context,
        builder: (context) {
          return AddDrawer(
            controller: drawerController,
            onSave: saveNewDrawer,
            onCancel: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }

    // Function to show the delete confirmation dialog
    void deleteNotify(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure you want to delete this drawer?"),
            actions: [
              TextButton(
                onPressed: () {
                  drawerProvider
                      .removeDrawer(index); // Remove drawer using provider
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
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
        margin: EdgeInsets.all(5.0),
        child: FloatingActionButton(
          onPressed: addNewDrawer,
          backgroundColor: BColors.white,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
