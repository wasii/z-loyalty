import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? prefixImage; // 👈 sirf image name
  final String? suffixImage; // 👈 sirf image name
  final bool isPassword;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixImage,
    this.suffixImage,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // rebuild on focus change
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget? _buildPrefix() {
    if (widget.prefixImage == null) return null;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.asset(
        "$kIconFolder${widget.prefixImage!}",
        height: 20,
        width: 20,
      ),
    );
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        icon: Image.asset(
          _obscureText
              ? "${kIconFolder}eyeclosed_icon.png"
              : "${kIconFolder}eyeopen_icon.png",
          height: 20,
          width: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    if (widget.suffixImage != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          "$kIconFolder${widget.suffixImage!}",
          height: 20,
          width: 20,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = _focusNode.hasFocus;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: kTextFieldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? kPrimaryColor : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: kPrimaryColor.withAlpha(100),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: kTextFieldPlaceholderColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: _buildPrefix(),
          suffixIcon: _buildSuffix(),
        ),
        style: GoogleFonts.inter(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
