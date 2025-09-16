// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
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
  final TextEditingController phoneNumberController = TextEditingController();
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
    phoneNumberController.addListener(_updateButtonState);
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
          phoneNumberController.text.isNotEmpty &&
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
    phoneNumberController.dispose();
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
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    AuthenticationHeader(),
                    AuthenticationHeaderText(
                      title: 'Sign up',
                      subtitle:
                          'Create your account and enjoy a rewarding experience',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: nameController,
                              hintText: "Enter your Full name",
                              prefixImage: "iconusername.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: userNameController,
                              hintText: "Enter your Username",
                              prefixImage: "iconusername.png",
                              keyboardType: TextInputType.phone,
                              focusNode: userFocusNode,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: passwordController,
                              hintText: "Enter your Password",
                              prefixImage: "iconpassword.png",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: confirmPasswordController,
                              hintText: "Confirm Password",
                              prefixImage: "iconpassword.png",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120, // 👈 first field ka fixed width
                                  child: AppTextField(
                                    controller: passwordController,
                                    hintText: "92",
                                    prefixImage: "iconpakistan.png",
                                    suffixImage: "icondropdown.png",
                                    editable: false,
                                  ),
                                ),
                                const SizedBox(width: 5), // spacing
                                Expanded(
                                  child: AppTextField(
                                    controller: phoneNumberController,
                                    hintText: "Enter Phone number",
                                    prefixImage: "iconphonenumber.png",
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: emailController,
                              hintText: "Enter your Email Address",
                              prefixImage: "iconmessage.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: cityController,
                              hintText: "City",
                              prefixImage: "iconlocation.png",
                              suffixImage: "icondropdown.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: experienceInYearsController,
                              hintText: "Experience in years",
                              prefixImage: "iconpassword.png",
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: experienceInYearsController,
                              hintText: "Enter your Full Address",
                              prefixImage: "iconaddress.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: easyPaisaController,
                              hintText: "Easypaisa Account Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: jazzCashController,
                              hintText: "Jazzcash Account Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: bankDetailsController,
                              hintText: "Bank Account Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: remarksController,
                              hintText: "Enter your remarks",
                              prefixImage: "iconchat.png",
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Sign Up',
                              onPressed: () {
                                // userregistration();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegistrationSuccessful(),
                                  ),
                                );
                              },
                              enabled: true,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you already have an account? ",
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login Now",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
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
              ),
            ),
            if (isLoading) Loader(),
          ],
        ),
      ),
    );
  }

  void checkUsername() async {
    if (userNameController.text.isEmpty) {
      return;
    }
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
