import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/components/primary_button.dart';

class InstallationSuccessfull extends StatelessWidget {
  final String message;
  const InstallationSuccessfull({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final RegExp regex = RegExp(r'^(.*?earned )(\d+)(.*)$');
    final match = regex.firstMatch(message);
    final beforePoints = match?.group(1) ?? '';
    final points = match?.group(2) ?? '';
    final afterPoints = match?.group(3) ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomNavigationBarWithBackButton(isVisible: false),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Image.asset("${kIconFolder}iconsuccessful.png", height: 240),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          beforePoints,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              points,
                              style: GoogleFonts.inter(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              afterPoints,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Keep going to unlock more rewards',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kTextFieldPlaceholderColor,
                    ),
                  ),
                  Spacer(),
                  PrimaryButton(
                    text: 'Back to Claim Points',
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
