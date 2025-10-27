import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class PointsHistoryCell extends StatelessWidget {
  final String detail;
  final String inventorytype;
  final String points;

  const PointsHistoryCell({
    super.key,
    required this.detail,
    required this.inventorytype,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: kBoxBackgroundColor,
          border: Border.all(color: kBoxBackgroundColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inventorytype,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                Text(
                  detail,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kTextFieldPlaceholderColor,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              points,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
