import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_otp_fields.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/send_otp_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/pages/authentication/update_password/update_new_password.dart';

class EnterOTPPage extends StatefulWidget {
  final String phoneNumber;
  const EnterOTPPage({super.key, required this.phoneNumber});

  @override
  State<EnterOTPPage> createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  bool isButtonEnabled = false;
  bool isLoading = false;
  int secondsRemaining = 60;
  Timer? _timer;
  bool isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      isResendEnabled = false;
      secondsRemaining = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          isResendEnabled = true;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void handleOTPChanged(String code) {
    setState(() {
      isButtonEnabled = code.length == 5;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: const CircleBorder(),
                        minimumSize: Size(40, 40),
                      ),
                      child: Image.asset(
                        '${kIconFolder}back_button.png',
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Check your inbox",
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
                      text: 'We have sent the verification code on ',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13),
                      ),
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      isResendEnabled
                          ? "You can now resend the code."
                          : "Resend code in 00:${secondsRemaining.toString().padLeft(2, '0')}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive OTP?",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: isResendEnabled
                            ? () {
                                resendOTP();
                              }
                            : null,
                        child: Text(
                          "Resend code",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isResendEnabled
                                  ? kPrimaryColor
                                  : Colors.grey,
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
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  void resendOTP() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final response = await api.request(
        path: SendOTP,
        type: RequestType.post,
        data: {'username': widget.phoneNumber},
        useFormData: true,
      );

      final json = response.data;
      final model = SendOTPModel.fromJson(json);

      if (model.error == 0) {
        _startResendTimer();
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Resend OTP Failed"),
            content: Text(model.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sent OTP Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
