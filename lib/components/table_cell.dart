import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

Widget tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget tableHeader(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget tableCellWithActions({
  required VoidCallback onEdit,
  required VoidCallback onView,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Icon(Icons.edit, size: 20, color: kPrimaryColor),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: onView,
          child: Icon(Icons.search, size: 20, color: kPrimaryColor),
        ),
      ],
    ),
  );
}
