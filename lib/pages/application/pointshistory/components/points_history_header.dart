import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';

class PointsHistoryHeader extends StatelessWidget {
  const PointsHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomHeading(heading: 'Points History'),
        Spacer(),
        IntrinsicWidth(
          child: Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Date: N/A',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  '${kIconFolder}icondropdown.png',
                  width: 10,
                  height: 5.83,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
