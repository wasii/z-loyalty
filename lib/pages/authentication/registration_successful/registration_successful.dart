import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/primary_button.dart';

class RegistrationSuccessful extends StatelessWidget {
  const RegistrationSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  AuthenticationHeader(),
                  SizedBox(height: 50),
                  Image.asset("${kIconFolder}iconsuccessful.png", height: 240),
                  Text(
                    "Congratulations,\nYou are all set!",
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Your Account has been created",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  PrimaryButton(
                    text: 'Get Started',
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
