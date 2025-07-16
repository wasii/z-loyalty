import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/pages/authentication/registration_successful/registration_successful.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController experienceInYearsController =
      TextEditingController();
  //VISITING CARD PICTURE
  final TextEditingController addressController = TextEditingController();
  final TextEditingController easyPaisaController = TextEditingController();
  final TextEditingController jazzCashController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  bool isButtonEnabled = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateButtonState);
    userNameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
    whatsappNumberController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    cityController.addListener(_updateButtonState);
    experienceInYearsController.addListener(_updateButtonState);
    addressController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          whatsappNumberController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          experienceInYearsController.text.isNotEmpty &&
          addressController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    whatsappNumberController.dispose();
    emailController.dispose();
    cityController.dispose();
    experienceInYearsController.dispose();

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
                children: [
                  const SizedBox(height: 5),
                  // Top logo + text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        '${kLogoFolder}ziewnic_horizontal_logo.png',
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "LOYALTY",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                height: 1.0,
                              ),
                            ),
                          ),
                          Text(
                            "PROGRAM",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 19,
                                height: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            CustomInputField(
                              controller: nameController,
                              headingText: 'Name',
                              hintText: 'Type Full Name',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: userNameController,
                              headingText: 'Username',
                              hintText: 'Type username',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: passwordController,
                              headingText: 'Password',
                              hintText: 'Type Password',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: confirmPasswordController,
                              headingText: 'Confirm Password',
                              hintText: 'Confirm Password',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: whatsappNumberController,
                              headingText: 'Whatsapp Number',
                              hintText: 'Type Whatsapp Number',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: emailController,
                              headingText: 'Email',
                              hintText: 'Type Email Address',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: cityController,
                              headingText: 'City',
                              hintText: 'Type Your City',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: experienceInYearsController,
                              headingText: 'Experience in Years',
                              hintText: 'Type username',
                              isRequired: true,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: userNameController,
                              headingText: 'Visiting Card Picture',
                              hintText: 'Tap to Add Media',
                              isRequired: false,
                              textHeight: 150,
                            ),
                            CustomInputField(
                              controller: addressController,
                              headingText: 'Address',
                              hintText: 'Type Address',
                              isRequired: true,
                              textHeight: 150,
                            ),
                            CustomInputField(
                              controller: easyPaisaController,
                              headingText: 'Easy Paisa',
                              hintText: 'Type Easy Paisa Details',
                              isRequired: false,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: jazzCashController,
                              headingText: 'Jazz Cash',
                              hintText: 'Type Jazz Cash Details',
                              isRequired: false,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: bankDetailsController,
                              headingText: 'Bank Account',
                              hintText: 'Type Bank Account Details',
                              isRequired: false,
                              textHeight: 57,
                            ),
                            CustomInputField(
                              controller: remarksController,
                              headingText: 'Remarks',
                              hintText: '',
                              isRequired: false,
                              textHeight: 150,
                            ),
                            SizedBox(height: 20),
                            CustomPrimaryButton(
                              text: 'Register',
                              isDisabled: isButtonEnabled,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationSuccessful(),
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "SIGN IN",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ), // TextStyle(decoration: TextDecoration.underline)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40), // Bottom spacing
                          ],
                        ),
                      ),
                    ),
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
