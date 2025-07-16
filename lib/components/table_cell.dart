import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        textAlign: TextAlign.center),
  );
}

Widget tableHeader(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        textAlign: TextAlign.center),
  );
}
