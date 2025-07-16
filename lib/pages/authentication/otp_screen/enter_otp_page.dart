import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_otp_fields.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/pages/authentication/update_password/update_new_password.dart';

class EnterOTPPage extends StatefulWidget {
  final String email;
  const EnterOTPPage({super.key, required this.email});

  @override
  State<EnterOTPPage> createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  bool isButtonEnabled = false;

  void handleOTPChanged(String code) {
    if (code.length == 5) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('${kLogoFolder}app_background_2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // No extra padding
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape:
                            const CircleBorder(), // optional: makes it circular
                        minimumSize: Size(40, 40), // Make it same as image size
                      ),
                      child: Image.asset(
                        '${kIconFolder}back_button.png',
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Check your email",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      text: 'We sent a reset link to ',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13),
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextSpan(
                          text:
                              ' enter 5 digit code that mentioned in the email.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  OTPInputWidget(
                    onCompleted: (code) {
                      print("OTP entered: $code");
                    },
                    onChanged: handleOTPChanged,
                  ),
                  SizedBox(height: 30),
                  CustomPrimaryButton(
                    text: 'Verify Code',
                    isDisabled: isButtonEnabled,
                    showImage: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateNewPassword(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Haven't got email yet?",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Resend email",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
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
