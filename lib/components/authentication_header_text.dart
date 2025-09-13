import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationHeaderText extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthenticationHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
