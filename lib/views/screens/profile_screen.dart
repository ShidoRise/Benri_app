import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/profile_info_card.dart';
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
          title: 'Cài đặt',
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            return ListView(
              children: [
                const SizedBox(height: 20),
                if (viewModel.isLoggedIn)
                  ProfileInfoCard(
                    title: 'Thông tin hồ sơ',
                    name: viewModel.userInfo['name'] ?? '',
                    email: viewModel.userInfo['email'] ?? '',
                    children: [],
                  ),
                if (!viewModel.isLoggedIn)
                  ProfileInfoCard(
                    title: 'Thông tin hồ sơ',
                    name: 'Khách',
                    email: 'abcxyz@gmail.com',
                    children: [
                      Text('Vui lòng đăng nhập để truy cập thêm tính năng',
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                textTitleSettingWidget('Cài đặt', context),
                settingItemWidget(
                    context, Icons.notifications_none, 'Thông báo'),
                settingItemWidget(context, Icons.dark_mode, 'Chế độ tối'),
                textTitleSettingWidget('Quyền riêng tư', context),
                settingItemWidget(
                    context, Icons.star_border, 'Đánh giá ứng dụng'),
                settingItemWidget(context, Icons.share, 'Chia sẻ ứng dụng'),
                settingItemWidget(context, Icons.mail_outline, 'Liên hệ'),
                settingItemWidget(context, Icons.feedback_outlined, 'Phản hồi'),
                textTitleSettingWidget('Tài khoản', context),
                if (!viewModel.isLoggedIn)
                  settingItemWidget(context, Icons.login, 'Đăng nhập'),
                if (viewModel.isLoggedIn) ...[
                  settingItemWidget(context, Icons.password, 'Đổi mật khẩu'),
                  settingItemWidget(context, Icons.logout, 'Đăng xuất'),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
