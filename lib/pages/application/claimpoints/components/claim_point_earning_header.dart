import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/models/claim_points_model.dart';
import 'package:loyalty_program/pages/application/claimpoints/claim_points_history.dart';

class ClaimPointsEarningHeadingSection extends StatelessWidget {
  final List<InstallationClaim> claims;
  const ClaimPointsEarningHeadingSection({super.key, required this.claims});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomHeading(heading: 'Earning History'),
        Spacer(),
        TextButton(
          onPressed: claims.isEmpty
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClaimPointsHistory(claims: claims),
                    ),
                  );
                },
          child: Text(
            'View All',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: claims.isEmpty ? Colors.grey : kPrimaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
