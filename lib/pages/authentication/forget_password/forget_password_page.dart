// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/send_otp_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/pages/authentication/otp_screen/enter_otp_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      final text = phoneNumberController.text;
      isButtonEnabled = text.isNotEmpty && text.length == 11;
      if (isButtonEnabled) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
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
                    "Forget Password",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Please enter your phone number to reset the password",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomInputField(
                    controller: phoneNumberController,
                    headingText: 'Phone Number',
                    hintText: 'Enter Your Phone Number',
                    isRequired: true,
                    textHeight: 54,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              sendOTP();
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.disabled)) {
                              return kDefaultDisabledButtonColor;
                            }
                            return kPrimaryColor;
                          },
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 24),
                          Text(
                            "Reset Password",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Image.asset(
                            '${kIconFolder}forward_arrow.png',
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
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

  void sendOTP() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final String phoneNumber = phoneNumberController.text;

      final response = await api.request(
        path: SendOTP,
        type: RequestType.post,
        data: {'username': phoneNumber},
        useFormData: true,
      );

      final json = response.data;
      final model = SendOTPModel.fromJson(json);

      if (model.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOTPPage(phoneNumber: phoneNumber),
          ),
        );
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Sent OTP Failed"),
            content: Text(model.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  phoneNumberController.text = '';
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
