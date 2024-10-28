// ignore_for_file: use_build_context_synchronously

import 'package:benri_app/utils/styles/text_style.dart';
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
      child: LoginScreenContent(),
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
        title: Text('Sign In', style: AppTextStyle.title()),
        backgroundColor: BColors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 338,
                height: 40,
                child: Text(
                  'Welcome to Benri',
                  style: TextStyle(
                    color: Color(0xFF010F07),
                    fontSize: 33,
                    fontFamily: 'Yu Gothic UI',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.22,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 274,
                height: 50,
                child: Text(
                  'Enter your Phone number or Email address for sign in. Enjoy your food :)',
                  style: TextStyle(
                    color: Color(0xFF868686),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.40,
                  ),
                ),
              ),
              SizedBox(height: 25),
              _buildTextField("Email", viewModel.emailController, false),
              SizedBox(height: 10),
              _buildTextField("Password", viewModel.passwordController, true),
              SizedBox(height: 20),
              Center(
                  child: GestureDetector(
                      onTap: () {
                        viewModel.routeToForgotPassword(context);
                      },
                      child: Text("Forget Password?",
                          style: TextStyle(fontSize: 16)))),
              SizedBox(height: 20),
              _buildSignInButton(context, viewModel),
              SizedBox(height: 20),
              _buildCreateAccountRow(context, viewModel),
              SizedBox(height: 10),
              Center(child: Text("Or")),
              SizedBox(height: 10),
              _buildSocialButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Check your network connection')),
                  );
                },
                color: Color(0xFF395998),
                text: 'CONNECT WITH FACEBOOK',
                icon: 'assets/icons/facebook.svg',
              ),
              SizedBox(height: 10),
              _buildSocialButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Check your network connection')),
                  );
                },
                color: const Color(0xFF4285F4),
                text: 'CONNECT WITH GOOGLE',
                icon: 'assets/icons/google.svg',
                textColor: Colors.white,
                borderColor: Colors.grey.shade300,
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
            style: TextStyle(color: BColors.textPrimary, fontSize: 18),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          cursorColor: BColors.primary,
          decoration: InputDecoration(
            hintText: isPassword ? 'Abc123' : 'Xample@gmail.com',
            hintStyle: TextStyle(color: BColors.textSecondary, fontSize: 16),
            focusedBorder: UnderlineInputBorder(
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
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    if (await viewModel.login()) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Check your network connection')),
                      );
                    }
                  } finally {
                    viewModel.setLoading(false);
                  }
                }
              },
        child: viewModel.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text('SIGN IN'),
      ),
    );
  }

  Widget _buildCreateAccountRow(
      BuildContext context, LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account", style: TextStyle(fontSize: 16)),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            viewModel.routeToSignUp(context);
          },
          child: Text('Create new account',
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
            SizedBox(width: 8),
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
