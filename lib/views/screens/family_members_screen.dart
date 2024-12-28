import 'package:benri_app/view_models/family_view_model.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class FamilyMembersScreen extends StatelessWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FamilyViewModel(),
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<FamilyViewModel>().loadFamilyMembers();
        });

        return Scaffold(
          appBar: const BAppBar(title: 'Family Members'),
          body: Consumer<FamilyViewModel>(
            builder: (context, viewModel, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.members.length,
                itemBuilder: (context, index) {
                  final member = viewModel.members[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
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
                      title: Text(
                        member.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: member.role == 'admin'
                              ? BColors.primaryFirst.withOpacity(0.1)
                              : BColors.lightGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member.role.toUpperCase(),
                          style: TextStyle(
                            color: member.role == 'admin'
                                ? BColors.primaryFirst
                                : BColors.darkGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
