// ignore_for_file: use_build_context_synchronously

import 'package:benri_app/utils/styles/text_style.dart';
import 'package:benri_app/views/screens/basket_screen.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/login_view_model.dart';
import 'package:benri_app/utils/constants/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 338,
                height: 40,
                child: Text(
                  'Chào mừng đến với Benri',
                  style: TextStyle(
                    fontSize: 33,
                    fontFamily: 'Yu Gothic UI',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.22,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 274,
                height: 50,
                child: Text(
                  'Nhập địa chỉ email của bạn để đăng nhập. Thưởng thức món ăn nhé :)',
                  style: TextStyle(
                    color: Color(0xFF868686),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.40,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField("Email", viewModel.emailController, false),
              const SizedBox(height: 10),
              _buildTextField("Mật khẩu", viewModel.passwordController, true),
              const SizedBox(height: 20),
              Center(
                  child: GestureDetector(
                      onTap: () {
                        viewModel.routeToForgotPassword(context);
                      },
                      child: const Text("Quên mật khẩu?",
                          style: TextStyle(fontSize: 16)))),
              const SizedBox(height: 20),
              _buildSignInButton(context, viewModel),
              const SizedBox(height: 20),
              _buildCreateAccountRow(context, viewModel),
              const SizedBox(height: 10),
              const Center(child: Text("Hoặc")),
              const SizedBox(height: 10),
              _buildSocialButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kiểm tra kết nối mạng')),
                  );
                },
                color: const Color(0xFF395998),
                text: 'KẾT NỐI VỚI FACEBOOK',
                icon: 'assets/icons/facebook.svg',
              ),
              const SizedBox(height: 10),
              _buildSocialButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kiểm tra kết nối mạng')),
                  );
                },
                color: const Color(0xFF4285F4),
                text: 'KẾT NỐI VỚI GOOGLE',
                icon: 'assets/icons/google.svg',
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          cursorColor: BColors.primary,
          decoration: InputDecoration(
            hintText: isPassword ? 'Abc123' : 'abcxyz@gmail.com',
            hintStyle:
                const TextStyle(color: BColors.textSecondary, fontSize: 16),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: BColors.primary, width: 2),
            ),
          ),
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, LoginViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: viewModel.isLoading ? Colors.grey : BColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: viewModel.isLoading
            ? null
            : () async {
                if (!viewModel.isLoading) {
                  viewModel.setLoading(true);
                  try {
                    if (viewModel.emailController.text.isEmpty ||
                        viewModel.passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Kiểm tra thông tin đăng nhập')),
                      );
                    } else if (await viewModel.login()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationMenu()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kiểm tra kết nối mạng')),
                      );
                    }
                  } finally {
                    viewModel.setLoading(false);
                  }
                }
              },
        child: viewModel.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Đăng nhập'),
      ),
    );
  }

  Widget _buildCreateAccountRow(
      BuildContext context, LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            viewModel.routeToSignUp(context);
          },
          child: const Text('Tạo tài khoản mới',
              style: TextStyle(color: BColors.primary, fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Color color,
    required String text,
    required String icon,
    Color textColor = Colors.white,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: borderColor != null ? BorderSide(color: borderColor) : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
