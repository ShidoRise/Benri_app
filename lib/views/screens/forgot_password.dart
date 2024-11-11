// import 'package:benri/utils/constants/colors.dart';
import 'package:benri_app/utils/styles/elevated_button_style.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 338,
              height: 40,
              child: Text(
                'Forgot Password',
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
                'Enter your email address and we will send you a reset instructions.',
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
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "EMAIL",
                    style:
                        TextStyle(color: BColors.textSecondary, fontSize: 16),
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 18),
                  cursorColor: BColors.primary,
                  decoration: InputDecoration(
                    hintText: 'xample@gmail.com',
                    hintStyle:
                        TextStyle(color: BColors.textSecondary, fontSize: 16),
                    // hintStyle: TextStyle(color: BColors.textSecondary, fontSize: 16),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: BColors.primary, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 50,
              width: double.infinity, // Makes the button take full width
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButtonStyle.primary(),
                child: const Text('RESET PASSWORD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
