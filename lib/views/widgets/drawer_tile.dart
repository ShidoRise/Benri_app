import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../screens/drawer_details_screen.dart';

class DrawerTile extends StatelessWidget {
  final String drawerName;
  final VoidCallback onDelete;

  const DrawerTile(
      {super.key, required this.drawerName, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Card(
          color: BColors.primaryFirst,
          elevation: 3,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              drawerName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DrawerDetailsScreen(drawerName: drawerName),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
