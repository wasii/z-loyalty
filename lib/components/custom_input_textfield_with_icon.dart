import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomInputFieldWithIcon extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String imageAssetPath;

  const CustomInputFieldWithIcon({
    super.key,
    required this.controller,
    required this.hintText,
    required this.imageAssetPath,
  });

  @override
  State<CustomInputFieldWithIcon> createState() =>
      _CustomInputFieldWithIconState();
}

class _CustomInputFieldWithIconState extends State<CustomInputFieldWithIcon> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            height: 54,
            width: 52,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Image.asset(
                widget.imageAssetPath,
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // TextField container
          Expanded(
            child: Container(
              height: 54,
              decoration: const BoxDecoration(
                color: kTextFieldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: widget.controller,
                obscureText: widget.hintText.toLowerCase() == 'password'
                    ? _obscureText
                    : false,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  suffixIcon: widget.hintText.toLowerCase() == 'password'
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                ),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
