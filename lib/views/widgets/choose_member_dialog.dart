import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/services/family_service.dart';

Future<String?> showChooseMemberDialog(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_outlined, size: 24),
              const SizedBox(width: 12),
              Text(
                'Chọn thành viên',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Chọn thành viên trong gia đình sẽ đi chợ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BColors.darkGrey,
                ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: FamilyService.familyMembers.length,
            itemBuilder: (context, index) {
              final member = FamilyService.familyMembers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(member.name),
                subtitle: Text(
                  member.role,
                  style: TextStyle(color: BColors.darkGrey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context, member.id);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
