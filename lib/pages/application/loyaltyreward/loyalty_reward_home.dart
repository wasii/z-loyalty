import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/pages/application/loyaltyreward/components/loyalty_reward_history.dart';

class LoyaltyRewardHome extends StatefulWidget {
  const LoyaltyRewardHome({super.key});

  @override
  State<LoyaltyRewardHome> createState() => _LoyaltyRewardHomeState();
}

class _LoyaltyRewardHomeState extends State<LoyaltyRewardHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoyaltyRewardHeader(
                    heading: 'Loyalty Rewards',
                    dateRange: 'Aug 10 - Sep 10, 2025',
                    pointsSpent: 1550,
                  ),
                  const SizedBox(height: 20),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                  LoyaltyRewardCell(
                    title: 'Bike Prize',
                    points: 1500,
                    date: 'Aug 14, 2025',
                    time: '06:54:22',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyRewardHeaderState extends StatefulWidget {
  const _LoyaltyRewardHeaderState();

  @override
  State<_LoyaltyRewardHeaderState> createState() =>
      _LoyaltyRewardHeaderStateState();
}

class _LoyaltyRewardHeaderStateState extends State<_LoyaltyRewardHeaderState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class LoyaltyRewardHeader extends StatelessWidget {
  const LoyaltyRewardHeader({
    super.key,
    required this.heading,
    required this.dateRange,
    required this.pointsSpent,
  });

  final String heading;
  final String dateRange;
  final int pointsSpent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeading(heading: heading),
              const SizedBox(height: 16),
              _DateRangePill(text: dateRange),
            ],
          ),
        ),
        _PointsSpentCard(points: pointsSpent),
      ],
    );
  }
}

class _DateRangePill extends StatelessWidget {
  const _DateRangePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
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
              text,
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
    );
  }
}

class _PointsSpentCard extends StatelessWidget {
  const _PointsSpentCard({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Points Spent',
            style: TextStyle(
              fontSize: 14,
              color: kTextFieldPlaceholderColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(kIconFolder + 'iconZcoin.png', height: 28, width: 28),
              const SizedBox(width: 8),
              Text(
                points.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextFieldHeadingNameColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoyaltyRewardCell extends StatefulWidget {
  const LoyaltyRewardCell({
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
  State<LoyaltyRewardCell> createState() => _LoyaltyRewardCellState();
}

class _LoyaltyRewardCellState extends State<LoyaltyRewardCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoyaltyRewardHistory()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBoxBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left Section - Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(widget.imagePath, width: 36, height: 33),
              ),
            ),
            const SizedBox(width: 16),
            // Middle Section - Title and Points
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.points} Points',
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
                  widget.date,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.time,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTextFieldHeadingNameColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
