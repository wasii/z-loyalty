import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class OTPInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String)? onChanged;

  const OTPInputWidget({
    super.key,
    this.length = 5,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(text: "-"),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChange(String value, int index) {
    if (value == "-") return;

    if (value.length > 1) {
      value = value.substring(value.length - 1);
      _controllers[index].text = value;
    }

    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        final allFilled = _controllers.every(
          (c) => c.text.isNotEmpty && c.text != "-",
        );
        if (allFilled) {
          _focusNodes[index].unfocus();
          widget.onCompleted(code);
        }
      }
    }
    setState(() {});
  }

  void _handleKeyPress(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty || _controllers[index].text == "-") {
        if (index > 0) {
          _controllers[index - 1].text = "-";
          _focusNodes[index - 1].requestFocus();
        }
      } else {
        _controllers[index].text = "-";
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        bool isActive =
            _focusNodes[index].hasFocus ||
            (_controllers[index].text.isNotEmpty &&
                _controllers[index].text != "-");

        return Container(
          width: 60,
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: kTextFieldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _controllers[index].text.isNotEmpty &&
                      _controllers[index].text != "-"
                  ? kPrimaryColor
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow:
                _controllers[index].text.isNotEmpty &&
                    _controllers[index].text != "-"
                ? [
                    BoxShadow(
                      color: kPrimaryColor.withAlpha(100),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _handleKeyPress(event, index),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _controllers[index].text == "-"
                      ? Colors.grey
                      : kPrimaryColor,
                ),
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _handleChange(value, index),
            ),
          ),
        );
      }),
    );
  }
}
