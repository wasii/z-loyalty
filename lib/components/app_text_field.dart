import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? prefixImage; // 👈 sirf image name
  final String? suffixImage; // 👈 sirf image name
  final bool isPassword;
  final TextInputType keyboardType; // 👈 naya field
  final FocusNode? focusNode;
  final bool editable;
  final String prevalue;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixImage,
    this.suffixImage,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.editable = true,
    this.prevalue = '',
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
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // rebuild on focus change
    });

    // 👇 yahan prevalue set karo
    if (widget.prevalue.isNotEmpty) {
      widget.controller.text = widget.prevalue;
    }
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👇 agar parent se nayi prevalue aayi ho to update kar do
    if (widget.prevalue != oldWidget.prevalue && widget.prevalue.isNotEmpty) {
      widget.controller.text = widget.prevalue;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
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
      return SizedBox(
        width: 5, // desired width
        height: 5, // desired height
        child: Center(
          child: Image.asset(
            "$kIconFolder${widget.suffixImage!}",
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = _focusNode.hasFocus;

    // 👇 agar prevalue hai to editable false aur text color black
    final bool isPrevalueSet = widget.prevalue.isNotEmpty;
    final bool isFieldEditable = isPrevalueSet ? false : widget.editable;

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
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        enabled: isFieldEditable,
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
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isPrevalueSet ? Colors.black : Colors.black87, // 👈
          ),
        ),
      ),
    );
  }
}
