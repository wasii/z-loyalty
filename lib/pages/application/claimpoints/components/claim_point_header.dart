import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';

class ClaimPointsHeaderSection extends StatelessWidget {
  const ClaimPointsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomHeading(heading: 'Claim Points'),
        Spacer(),
        Container(
          width: 92,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('${kIconFolder}iconZcoin.png', width: 20, height: 20),
              SizedBox(width: 5),
              Text(
                kUserPoints,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextFieldHeadingNameColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
