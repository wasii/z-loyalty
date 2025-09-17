import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_otp_fields.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthenticationHeader(),
                  AuthenticationHeaderText(
                    title: 'Enter OTP',
                    subtitle: 'Enter the 5-digit OTP code that we sent to',
                  ),
                  Transform.translate(
                    offset: const Offset(0, -25),
                    child: Text(
                      widget.phoneNumber,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  OTPInputWidget(
                    onCompleted: (code) {
                      print("OTP entered: $code");
                    },
                    onChanged: handleOTPChanged,
                  ),
                  SizedBox(height: 30),

                  PrimaryButton(
                    text: 'Verify',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateNewPassword(),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "00:${secondsRemaining.toString().padLeft(2, '0')} ",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isResendEnabled
                              ? () {
                                  resendOTP();
                                }
                              : null,
                          child: Text(
                            "Resend Code",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: isResendEnabled
                                    ? kPrimaryColor // ✅ enabled = primary color
                                    : Colors.grey, // ✅ disabled = gray
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
