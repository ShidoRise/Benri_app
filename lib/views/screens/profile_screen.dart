import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/views/widgets/text_title_setting_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
        appBar: BAppBar(
          title: 'Profile Settings',
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            return ListView(
              children: [
                const SizedBox(height: 20),
                settingItemWidget(context, Icons.person, 'Profile Information'),
                textTitleSettingWidget('Profile'),
                settingItemWidget(
                    context, Icons.notifications_none, 'Notification'),
                settingItemWidget(context, Icons.dark_mode, 'Dark Mode'),
                textTitleSettingWidget('Settings'),
                settingItemWidget(context, Icons.star_border, 'Rate App'),
                settingItemWidget(context, Icons.share, 'Share App'),
                settingItemWidget(context, Icons.mail_outline, 'Contact'),
                settingItemWidget(context, Icons.feedback_outlined, 'Feedback'),
                textTitleSettingWidget('Privacy'),
                settingItemWidget(context, Icons.login, 'Login'),
                settingItemWidget(context, Icons.logout, 'Logout'),
              ],
            );
          },
        ),
      ),
    );
  }
}
