import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                  WelcomeText(),
                  SizedBox(height: 20),

                  //POINTS BALANCE
                  PointsBalance(),

                  SizedBox(height: 20),
                  PrizeBox(
                    title: 'Cash Prize',
                    value: '300',
                    prize: 'PKR 30,000',
                    imagePath: '${kIconFolder}iconcash.png',
                  ),

                  const SizedBox(height: 20),
                  PrizeBox(
                    title: 'Bike Prize',
                    value: '1500',
                    prize: 'Your Bike',
                    imagePath: '${kIconFolder}iconbike.png',
                  ),

                  const SizedBox(height: 20),
                  PrizeBox(
                    title: 'Umrah Package',
                    value: '3000',
                    prize: 'Your Umrah Ticket',
                    imagePath: '${kIconFolder}iconumrah.png',
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

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: kTextFieldPlaceholderColor,
          ),
        ),
        Text(
          "Afif Shaukat",
          style: GoogleFonts.inter(
            fontSize: 26,
            color: kTextHeadingColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PointsBalance extends StatelessWidget {
  const PointsBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Point Balance:",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "2450",
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Image.asset(
                "${kLogoFolder}ziewnic-white-logo.png",
                height: 40,
                width: 40,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                "Expiration Date: ",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                "Jan 13, 2026",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PrizeBox extends StatelessWidget {
  final String title;
  final String value;
  final String prize;
  final String imagePath;

  const PrizeBox({
    super.key,
    required this.title,
    required this.value,
    required this.prize,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: kBoxBackgroundColor, // green box
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👉 Left Side Texts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kPrimaryColor, // green box
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextFieldHeadingNameColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "Earned ",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: kTextFieldHeadingNameColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "$value Points",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kTextFieldHeadingNameColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "and Claimed",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prize,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kTextFieldHeadingNameColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              imagePath,
              height: 140,
              width: 138,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
