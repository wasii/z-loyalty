import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/pages/application/pointshistory/components/points_history_header_cell.dart';

class LoyaltyRewardHistory extends StatelessWidget {
  const LoyaltyRewardHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBarWithBackButton(
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoyaltyRewardHistoryHeader(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      PointsHistoryHeaderCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),

                      SizedBox(height: 20),

                      PointsHistoryHeaderCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),

                      SizedBox(height: 5),

                      LoyaltyRewardHistoryCell(),
                      SizedBox(height: 5),
                      LoyaltyRewardHistoryCell(),
                    ],
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

class LoyaltyRewardHistoryHeader extends StatelessWidget {
  const LoyaltyRewardHistoryHeader({
    super.key,
    required this.title,
    required this.points,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  final String title;
  final int points;
  final String date;
  final String time;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Section - Image
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kTextFieldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: Image.asset(imagePath, width: 36, height: 33)),
        ),
        const SizedBox(width: 16),
        // Middle Section - Title and Points
        Expanded(
          child: Column(
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
              const SizedBox(height: 4),
              Text(
                '$points Points',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        // Right Section - Date and Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kTextFieldHeadingNameColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kTextFieldHeadingNameColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LoyaltyRewardHistoryCell extends StatelessWidget {
  const LoyaltyRewardHistoryCell({super.key});

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
                  'Solar Hybrid Inverter 1.6 (KVA)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                Text(
                  'FGH85FF',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kTextFieldPlaceholderColor,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              '+30',
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
