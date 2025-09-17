import 'package:flutter/material.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/primary_button.dart';

class UpdatePasswordConfirm extends StatelessWidget {
  const UpdatePasswordConfirm({super.key});

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthenticationHeader(),
                  Image.asset("${kIconFolder}iconsuccessful.png", height: 200),
                  AuthenticationHeaderText(
                    title: 'Password reset\nsuccessfully!',
                    subtitle: 'Your password has been changed',
                  ),

                  Spacer(),
                  PrimaryButton(
                    text: 'Back to Login',
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
