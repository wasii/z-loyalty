import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomHeading extends StatelessWidget {
  final String heading;
  const CustomHeading({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: GoogleFonts.inter(
        fontSize: 26,
        color: kTextHeadingColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
