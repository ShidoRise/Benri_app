import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/widgets/custom_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget settingItemWidget(
  BuildContext context,
  IconData icon,
  String title,
) {
  return Consumer<ProfileViewModel>(builder: (context, viewModel, child) {
    bool? switchValue;
    if (title == 'Notification') {
      switchValue = viewModel.notificationEnabled;
    } else if (title == 'Dark Mode') {
      switchValue = viewModel.darkModeEnabled;
    }
    return ElevatedButton(
      onPressed: () {
        switch (title) {
          case 'Login':
            viewModel.login(context);
            break;
          case 'Logout':
            viewModel.logout();
            break;
          case 'Profile Information':
            viewModel.profileInformation(context);
            break;
          case 'Notification':
            viewModel.toggleNotification();
            break;
          case 'Dark Mode':
            viewModel.toggleDarkMode();
            break;
          case 'Rate App':
            viewModel.rateApp();
            break;
          case 'Share App':
            viewModel.shareApp();
            break;
          case 'Contact':
            viewModel.contact();
            break;
          case 'Feedback':
            viewModel.feedback();
            break;
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      child: SizedBox(
        height: 80,
        child: Center(
          child: ListTile(
            leading: Icon(icon, size: 32),
            title: Text(title),
            trailing: switchValue != null
                ? CustomSwitch(
                    value: switchValue,
                    onChanged: (value) {
                      if (title == 'Dark Mode') {
                        viewModel.toggleDarkMode();
                      } else if (title == 'Notification') {
                        viewModel.toggleNotification();
                      }
                    },
                  )
                : const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  });
}
