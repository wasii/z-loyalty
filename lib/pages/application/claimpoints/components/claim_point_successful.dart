import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/components/primary_button.dart';

class ClaimPointSuccessful extends StatelessWidget {
  final String rewardName;
  final String icon;
  const ClaimPointSuccessful({
    super.key,
    required this.rewardName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Upper image (background / decorative)
                        Positioned(
                          top: 0,
                          child: Image.asset(
                            "${kIconFolder}iconsuccessful.png",
                            height: 240,
                          ),
                        ),

                        /// Main success image
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(icon, height: 150),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "Congratulations",
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        rewardName,
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        " claimed!",
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
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
