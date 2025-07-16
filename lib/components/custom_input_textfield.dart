import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String headingText;
  final String hintText;
  final bool isRequired;
  final double textHeight;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.headingText,
    required this.hintText,
    required this.isRequired,
    required this.textHeight,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  bool get isPasswordField =>
      widget.headingText.toLowerCase() == 'password' ||
      widget.headingText.toLowerCase() == 'confirm password';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.headingText,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: kDefaultTextFieldColor,
                ),
              ),
            ),
            Text(
              widget.isRequired ? "*" : "",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: kTextFieldMandatoryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
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
              Expanded(
                child: Container(
                  height: widget.textHeight,
                  decoration: const BoxDecoration(
                    color: kTextFieldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    keyboardType: _getKeyboardType(widget.headingText),
                    controller: widget.controller,
                    obscureText: isPasswordField ? _obscureText : false,
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
                        vertical: 18,
                      ),
                      suffixIcon: isPasswordField
                          ? IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: kTextFieldTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  TextInputType _getKeyboardType(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('email') || lower.contains('your email')) {
      return TextInputType.emailAddress;
    } else if (lower.contains('whatsapp number') ||
        lower.contains('phone') ||
        lower.contains('number')) {
      return TextInputType.phone;
    }
    return TextInputType.text;
  }
}
