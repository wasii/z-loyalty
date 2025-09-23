import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class ClaimPointRewardSection extends StatelessWidget {
  final String title;
  final String points;
  final String imagePath;
  final bool editable;
  final VoidCallback onClaim;

  const ClaimPointRewardSection({
    super.key,
    required this.title,
    required this.points,
    required this.imagePath,
    this.editable = true,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60, // 👈 circle size
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white, // 👈 white circle background
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // half of width/height
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "$points Points",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kTextFieldPlaceholderColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: editable ? onClaim : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: editable
                  ? kPrimaryColor
                  : kTextFieldPlaceholderColor,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Claim",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
