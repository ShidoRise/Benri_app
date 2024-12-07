import 'package:benri_app/view_models/detail_profile_viewmodel.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailProfileScreen extends StatelessWidget {
  const DetailProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailProfileViewModel(),
      child: Scaffold(
        appBar: const BAppBar(title: 'Profile Information'),
        body: Consumer<DetailProfileViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Text('name: ${viewModel.userInfo['name'] ?? ''}'),
                Text('accessToken: ${viewModel.userInfo['accessToken'] ?? ''}'),
                Text(
                    'refreshToken: ${viewModel.userInfo['refreshToken'] ?? ''}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
