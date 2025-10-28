// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart'
    show AuthenticationHeaderText;
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/models/forgot_passwrod_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/pages/authentication/otp_screen/enter_otp_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    // setState(() {
    //   final text = phoneNumberController.text;
    //   isButtonEnabled = text.isNotEmpty;
    //   if (isButtonEnabled) {
    //     FocusScope.of(context).unfocus();
    //   }
    // });
    setState(() {
      isButtonEnabled = phoneNumberController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthenticationHeader(),
                  AuthenticationHeaderText(
                    title: 'Forgot Password?',
                    subtitle:
                        'If you’ve forgotten your password, enter your phone below',
                  ),
                  AppTextField(
                    controller: phoneNumberController,
                    hintText: "Enter your Phone Number",
                    prefixImage: "iconphonenumber.png",
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Confirm',
                    onPressed: () {
                      forgotPassword();
                    },
                    enabled: isButtonEnabled,
                  ),
                  const SizedBox(height: 0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  void forgotPassword() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final String phoneNumber = phoneNumberController.text;

      final response = await api.request(
        path: ForgotPassword,
        type: RequestType.post,
        data: {'username': phoneNumber},
        useFormData: true,
      );

      final json = response.data;
      final model = ForgotPasswrodModel.fromJson(json);

      if (model.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOTPPage(phoneNumber: phoneNumber),
          ),
        );
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Sent OTP Failed"),
            content: Text(model.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  phoneNumberController.text = '';
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sent OTP Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
