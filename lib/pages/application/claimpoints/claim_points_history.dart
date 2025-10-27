import 'package:flutter/material.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/models/claim_points_model.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_cell.dart';

class ClaimPointsHistory extends StatelessWidget {
  final List<InstallationClaim> claims;
  const ClaimPointsHistory({super.key, required this.claims});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBarWithBackButton(
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: CustomHeading(heading: 'Earning History'),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ...claims.map((claim) {
                      return Column(
                        children: [
                          ClaimPointsEarningHistoryCell(
                            title: claim.itemInstalled,
                            seiralnumber: claim.serialNumber,
                            points: '+${claim.pointsEarned}',
                            date: 'N/A', // Date field not available in API
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
