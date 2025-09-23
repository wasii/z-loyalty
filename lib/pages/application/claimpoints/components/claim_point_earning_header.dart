import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';

class ClaimPointsEarningHeadingSection extends StatelessWidget {
  const ClaimPointsEarningHeadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomHeading(heading: 'Earning History'),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'View All',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kPrimaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
