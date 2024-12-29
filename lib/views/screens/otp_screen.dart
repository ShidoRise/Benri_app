import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/utils/styles/elevated_button_style.dart';
import 'package:benri_app/view_models/otp_view_model.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class VerifyOTPScreen extends StatelessWidget {
  final Map<String, String> data;
  const VerifyOTPScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(),
      child: VerifyOTPScreenView(data: data),
    );
  }
}

class VerifyOTPScreenView extends StatelessWidget {
  final Map<String, String> data;
  VerifyOTPScreenView({super.key, required this.data});
  //viewmodel
  final OtpViewModel viewModel = OtpViewModel();
  //
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    String name = data['name']!;
    String email = data['email']!;
    String password = data['password']!;
    return Consumer<OtpViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verify OTP'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nhập mã xác thực được gửi đến',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 52,
                      height: 52,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          if (await viewModel.verifyOTP(
                            context,
                            _controllers
                                .map((controller) => controller.text)
                                .join(),
                            email,
                            password,
                            name,
                          )) {
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationMenu()),
                                (route) => false,
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButtonStyle.primary(),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Xác thực'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    bool rs = await AuthService.resendOTP(email, name);
                    if (rs) {
                      Fluttertoast.showToast(
                        msg: "Đã gửi lại OTP",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Gửi OTP thất bài",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: const Text('Gửi lại OTP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
