import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('${kLogoFolder}app_background_2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: const CircleBorder(),
                        minimumSize: Size(40, 40),
                      ),
                      child: Image.asset(
                        '${kIconFolder}back_button.png',
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Set a new password",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Create a new password. Ensure it differs from previous ones for security.",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomInputField(
                    controller: passwordController,
                    headingText: 'Password',
                    hintText: 'Enter your new password',
                    isRequired: true,
                    textHeight: 57,
                  ),
                  CustomInputField(
                    controller: confirmPasswordController,
                    headingText: 'Confirm Password',
                    hintText: 'Re-Enter your password',
                    isRequired: true,
                    textHeight: 57,
                  ),
                  SizedBox(height: 30),
                  CustomPrimaryButton(
                    text: 'Update Password',
                    isDisabled: isButtonEnabled,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdatePasswordConfirm(),
                        ),
                      );
                    },
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
