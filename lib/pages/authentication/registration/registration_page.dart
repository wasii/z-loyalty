// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/check_username_model.dart';
import 'package:loyalty_program/models/user_registration_model.dart';
import 'package:loyalty_program/network/api_service.dart';
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
  bool isLoading = false;

  bool usernameExist = false;

  final FocusNode userFocusNode = FocusNode();

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

    userFocusNode.addListener(() {
      if (!userFocusNode.hasFocus) {
        checkUsername();
      }
    });
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          experienceInYearsController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          usernameExist;
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

    userFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
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
                                keyboardType: TextInputType.phone,
                                focusNode: userFocusNode,
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
                                controller: addressController,
                                headingText: 'Address',
                                hintText: 'Type Address',
                                isRequired: true,
                                textHeight: 57,
                              ),
                              CustomInputField(
                                controller: emailController,
                                headingText: 'Email',
                                hintText: 'Type Email Address',
                                isRequired: false,
                                textHeight: 57,
                              ),
                              CustomInputField(
                                controller: whatsappNumberController,
                                headingText: 'Whatsapp Number',
                                hintText: 'Type Whatsapp Number',
                                isRequired: false,
                                textHeight: 57,
                              ),

                              // CustomInputField(
                              //   controller: userNameController,
                              //   headingText: 'Visiting Card Picture',
                              //   hintText: 'Tap to Add Media',
                              //   isRequired: false,
                              //   textHeight: 150,
                              // ),
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
                                textHeight: 57,
                              ),
                              SizedBox(height: 20),
                              CustomPrimaryButton(
                                text: 'Register',
                                isDisabled: isButtonEnabled,
                                onPressed: () {
                                  userregistration();
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
            if (isLoading) Loader(),
          ],
        ),
      ),
    );
  }

  void checkUsername() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final String phoneNumber = userNameController.text;

      final response = await api.request(
        path: CheckUserName,
        type: RequestType.post,
        data: {'username': phoneNumber},
        useFormData: true,
      );

      final json = response.data;
      final model = CheckUsernameModel.fromJson(json);

      if (model.error == 0) {
        usernameExist = true;
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(model.message),
            actions: [
              TextButton(
                onPressed: () {
                  usernameExist = false;
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
          title: const Text("Registration Failed"),
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

  void userregistration() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final response = await api.request(
        path: UserRegistration,
        type: RequestType.post,
        data: {
          'name': nameController.text,
          'username': userNameController.text,
          'password': passwordController.text,
          'city': cityController.text,
          'experience': experienceInYearsController.text,
          'address': addressController.text,
          'email': emailController.text,
          'whatsapp': whatsappNumberController.text,
          'easy_paise': easyPaisaController.text,
          'jazz_cash': jazzCashController.text,
          'bank_account': bankDetailsController.text,
          'remarks': remarksController.text,
        },
        useFormData: true,
      );

      final json = response.data;
      final user = UserRegistrationModel.fromJson(json);

      if (user.error == 0) {
        // Successful login
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistrationSuccessful(),
          ),
        );
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(user.message),
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
          title: const Text("Registration Failed"),
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
