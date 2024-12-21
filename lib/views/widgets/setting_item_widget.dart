import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/view_models/theme_provider.dart';
import 'package:benri_app/views/widgets/custom_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget settingItemWidget(
  BuildContext context,
  IconData icon,
  String title,
) {
  return Consumer2<ProfileViewModel, ThemeProvider>(
    builder: (context, profileViewModel, themeProvider, child) {
      bool? switchValue;

      if (title == 'Chế độ tối') {
        switchValue = themeProvider.isDarkMode;
      } else if (title == 'Thông báo') {
        switchValue = profileViewModel.notificationEnabled;
      }

      return ElevatedButton(
        onPressed: () {
          switch (title) {
            case 'Thông tin hồ sơ':
              profileViewModel.profileInformation(context);
              break;
            case 'Thông báo':
              profileViewModel.toggleNotification();
              break;
            case 'Chế độ tối':
              themeProvider.toggleTheme();
              break;
            case 'Đánh giá ứng dụng':
              profileViewModel.rateApp();
              break;
            case 'Chia sẻ ứng dụng':
              profileViewModel.shareApp();
              break;
            case 'Liên hệ':
              profileViewModel.contact();
              break;
            case 'Phản hồi':
              profileViewModel.feedback();
              break;
            case 'Đăng nhập':
              profileViewModel.login(context);
              break;
            case 'Đăng xuất':
              profileViewModel.logout();
              break;
            case 'Đổi mật khẩu':
              profileViewModel.changePassWord(context);
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
                        if (title == 'Chế độ tối') {
                          themeProvider.toggleTheme();
                        } else if (title == 'Thông báo') {
                          profileViewModel.toggleNotification();
                        }
                      },
                    )
                  : const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      );
    },
  );
}
