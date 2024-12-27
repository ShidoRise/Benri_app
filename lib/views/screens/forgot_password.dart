import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/utils/styles/elevated_button_style.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false; // State to track if OTP is sent

  void _showToast(String message, {Color backgroundColor = Colors.green}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
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
                'Enter your email address and we will send you a reset instructions.',
                style: TextStyle(
                  color: Color(0xFF868686),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.40,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "EMAIL",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextField(
                  style: const TextStyle(fontSize: 18),
                  controller: _emailController,
                  cursorColor: BColors.primary,
                  decoration: InputDecoration(
                    hintText: 'example@gmail.com',
                    hintStyle: TextStyle(
                      color: BColors.textSecondary,
                      fontSize: 16,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: BColors.primary, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            const SizedBox(height: 25),
            if (_otpSent) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "OTP",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 18),
                    controller: _otpController,
                    cursorColor: BColors.primary,
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      hintStyle: TextStyle(
                        color: BColors.textSecondary,
                        fontSize: 16,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: BColors.primary, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              try {
                                // Simulate OTP verification
                                await AuthService.xacthucReset(
                                    _emailController.text.trim(),
                                    _otpController.text.trim());
                                _showToast(
                                  "OTP xác thực thành công! Kiểm tra email của bạn",
                                  backgroundColor: Colors.green,
                                );
                              } catch (error) {
                                _showToast(
                                  "Failed to verify OTP. Try again.",
                                  backgroundColor: Colors.red,
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                      style: ElevatedButtonStyle.primary(),
                      child: const Text('VERIFY OTP'),
                    ),
                  ),
                ],
              ),
            ],
            if (!_otpSent)
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            await AuthService.forgotPassword(
                              _emailController.text.trim(),
                            );
                            _showToast(
                              "OTP Sent Successfully!",
                              backgroundColor: Colors.green,
                            );
                            setState(() => _otpSent = true);
                          } catch (error) {
                            _showToast(
                              "Failed to send OTP. Try again.",
                              backgroundColor: Colors.red,
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButtonStyle.primary(),
                  child: const Text('SEND OTP'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
