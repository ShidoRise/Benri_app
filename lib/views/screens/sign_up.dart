import 'package:benri_app/utils/styles/elevated_button_style.dart';
import 'package:benri_app/utils/styles/text_style.dart';
import 'package:benri_app/views/screens/otp_screen.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/signup_view_model.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: AppTextStyle.title()),
        backgroundColor: BColors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 338,
                height: 40,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF010F07),
                    fontSize: 33,
                    fontFamily: 'Yu Gothic UI',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.22,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                width: 274,
                height: 50,
                child: Text(
                  'Enter your Name, Email and Password for sign up.',
                  style: TextStyle(
                    color: Color(0xFF868686),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.40,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              _buildInputField('FULL NAME', 'Nguyen Van An',
                  viewModel.nameController, false),
              _buildInputField('EMAIL', 'xample@gmail.com',
                  viewModel.emailController, false),
              _buildInputField(
                  'PASSWORD', 'Abc123', viewModel.passwordController, true),
              _buildInputField('CONFIRM PASSWORD', 'Abc123',
                  viewModel.confirmPasswordController, true),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers the text horizontally
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Have an account?",
                      style: TextStyle(color: BColors.primary),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (viewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 50,
                  width: double.infinity, // Makes the button take full width
                  child: ElevatedButton(
                    style: ElevatedButtonStyle.primary(),
                    onPressed: () async {
                      viewModel.setIsLoading(true);
                      if (await viewModel.signUp()) {
                        viewModel.setIsLoading(false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyOTPScreen(data: {
                              'name': viewModel.nameController.text,
                              'email': viewModel.emailController.text,
                              'password': viewModel.passwordController.text
                            }),
                          ),
                        );
                      } else {
                        viewModel.setIsLoading(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(viewModel.errorMessage,
                                  style: const TextStyle(
                                      color: BColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))),
                        );
                      }
                    },
                    child: const Text('SIGN UP'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hintText,
      TextEditingController controller, bool isPassword) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(color: BColors.textSecondary, fontSize: 16),
          ),
        ),
        TextField(
          controller: controller,
          cursorColor: BColors.primary,
          style: const TextStyle(fontSize: 18),
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: BColors.textSecondary, fontSize: 16),
            // hintStyle: TextStyle(color: BColors.textSecondary, fontSize: 16),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: BColors.primary, width: 2),
            ),
          ),
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
