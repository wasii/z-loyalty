import 'package:flutter/material.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/pages/authentication/update_password_confirm/update_password_confirm.dart';

class UpdateNewPassword extends StatefulWidget {
  const UpdateNewPassword({super.key});

  @override
  State<UpdateNewPassword> createState() => _UpdateNewPasswordState();
}

class _UpdateNewPasswordState extends State<UpdateNewPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthenticationHeader(),
                  AuthenticationHeaderText(
                    title: 'Reset Password',
                    subtitle:
                        'If you’ve forgotten your password, enter your email below',
                  ),
                  AppTextField(
                    controller: passwordController,
                    hintText: "New Password",
                    prefixImage: "iconpassword.png",
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    prefixImage: "iconpassword.png",
                    isPassword: true,
                  ),
                  SizedBox(height: 30),
                  PrimaryButton(
                    text: 'Save',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdatePasswordConfirm(),
                        ),
                      );
                    },
                    enabled: isButtonEnabled,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
