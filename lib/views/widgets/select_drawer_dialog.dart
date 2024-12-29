import 'package:benri_app/view_models/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<String?> showSelectDrawerBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final drawerProvider = Provider.of<DrawerProvider>(context);
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn ngăn tủ lạnh',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: drawerProvider.drawers.length,
              itemBuilder: (context, index) {
                final drawer = drawerProvider.drawers[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(drawer),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pop(context, drawer),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
