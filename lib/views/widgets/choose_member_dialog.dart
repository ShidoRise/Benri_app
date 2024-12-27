import 'package:flutter/material.dart';
import 'package:benri_app/services/family_service.dart';

Future<String?> showChooseMemberDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ListView.builder(
      shrinkWrap: true,
      itemCount: FamilyService.familyMembers.length,
      itemBuilder: (context, index) {
        final member = FamilyService.familyMembers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              member.name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(member.name),
          subtitle: Text(member.role),
          onTap: () => Navigator.pop(context, member.id),
        );
      },
    ),
  );
}
